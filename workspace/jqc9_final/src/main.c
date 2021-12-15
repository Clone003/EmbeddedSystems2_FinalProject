/******************************************************************************/
/*                                                                            */
/* main.c -- Demo project for the PmodOLED IP                                 */
/*                                                                            */
/******************************************************************************/
/* Author: Arthur Brown                                                       */
/* Copyright 2016, Digilent Inc.                                              */
/******************************************************************************/
/* File Description:                                                          */
/*                                                                            */
/* This demo_project initializes and uses the PmodOLED to display strings     */
/* and show different available fill patterns.                                */
/*                                                                            */
/* In order to properly quit the demo, a serial terminal application should   */
/* be connected to your board over UART at the appropriate Baud rate, as      */
/* specified below.                                                           */
/*                                                                            */
/******************************************************************************/
/* Revision History:                                                          */
/*                                                                            */
/*    06/20/2016(ArtVVB):   Created                                           */
/*    12/15/2016(jPeyron):  Edited for better use for OnboardOLED in, as well */
/*                          as inverting the white and black                  */
/*    08/25/2017(ArtVVB):   Added proper cache management functions           */
/*    02/17/2018(atangzwj): Validated for Vivado 2017.4                       */
/*                                                                            */
/******************************************************************************/
/* Baud Rates:                                                                */
/*                                                                            */
/*    Microblaze: 9600 or what was specified in UARTlite core                 */
/*    Zynq: 115200                                                            */
/*                                                                            */
/******************************************************************************/

/* ------------------------------------------------------------ */
/*                  Include File Definitions                    */
/* ------------------------------------------------------------ */

#include <stdio.h>
#include "sleep.h"
#include "xil_cache.h"
#include "xil_printf.h"
#include "xparameters.h"

#include "PmodOLED.h"
#include "PmodBT2.h"
#include "PmodHYGRO.h"
#include "PmodGPS.h"

/* ------------------------------------------------------------ */
/*                  Definitions                                 */
/* ------------------------------------------------------------ */
#include "xuartps.h"
typedef XUartPs SysUart;
#define SysUart_Send            XUartPs_Send
#define SysUart_Recv            XUartPs_Recv
#define SYS_UART_DEVICE_ID      XPAR_PS7_UART_1_DEVICE_ID
#define BT2_UART_AXI_CLOCK_FREQ 50000000 	//FCLK1

#define TIMER_FREQ_HZ 50000000 //FCLK? for hygro

#ifdef XPAR_CPU_CORTEXA9_0_CPU_CLK_FREQ_HZ
#define PERIPHERAL_CLK 50000000 // FCLK0 frequency is not in xparameters.h for some reason
#else
#define PERIPHERAL_CLK XPAR_CPU_M_AXI_DP_FREQ_HZ
#endif

#ifdef XPAR_XINTC_NUM_INSTANCES
#include "xintc.h"
#define INTC         XIntc
#define INTC_HANDLER XIntc_InterruptHandler
#else
#ifdef XPAR_SCUGIC_0_DEVICE_ID
#include "xscugic.h"
#define INTC         XScuGic
#define INTC_HANDLER XScuGic_InterruptHandler
#endif
#endif

/* ------------------------------------------------------------ */
/*                  Global Variables                            */
/* ------------------------------------------------------------ */

PmodOLED myoled;
PmodBT2 mybt;
SysUart myUart;
PmodHYGRO myHygro;
PmodGPS GPS;
INTC intc;

/* ------------------------------------------------------------ */
/*                  Forward Declarations                        */
/* ------------------------------------------------------------ */

void DemoInitialize();
void DemoRun();
void SysUartInit();
void DemoCleanup();
void EnableCaches();
void DisableCaches();

int SetupInterruptSystem(PmodGPS *InstancePtr, u32 interruptDeviceID,
      u32 interruptID);

// To change between PmodOLED and OnBoardOLED is to change Orientation
const u8 orientation = 0x0; // Set up for Normal PmodOLED(false) vs normal
                            // Onboard OLED(true)
const u8 invert = 0x0; // true = whitebackground/black letters
                       // false = black background /white letters

/* ------------------------------------------------------------ */
/*                  Function Definitions                        */
/* ------------------------------------------------------------ */

int main() {
   DemoInitialize();
   DemoRun();
   DemoCleanup();

   return 0;
}

void DemoInitialize() {
   EnableCaches();
   xil_printf("Init Started\n\r");
   OLED_Begin(&myoled, XPAR_PMODOLED_0_AXI_LITE_GPIO_BASEADDR,
         XPAR_PMODOLED_0_AXI_LITE_SPI_BASEADDR, orientation, invert);
   SysUartInit();
   BT2_Begin (
      &mybt,
      XPAR_PMODBT2_0_AXI_LITE_GPIO_BASEADDR,
      XPAR_PMODBT2_0_AXI_LITE_UART_BASEADDR,
      BT2_UART_AXI_CLOCK_FREQ,
      115200
   );
   HYGRO_begin(
      &myHygro,
      XPAR_PMODHYGRO_0_AXI_LITE_IIC_BASEADDR,
      0x40, // Chip address of PmodHYGRO IIC
      XPAR_PMODHYGRO_0_AXI_LITE_TMR_BASEADDR,
      XPAR_PMODHYGRO_0_DEVICE_ID,
      TIMER_FREQ_HZ // Clock frequency of AXI bus, used to convert timer data
   );

   GPS_begin(&GPS, XPAR_PMODGPS_0_AXI_LITE_GPIO_BASEADDR,
         XPAR_PMODGPS_0_AXI_LITE_UART_BASEADDR, PERIPHERAL_CLK);
   // Set up interrupts for a Zynq system
   SetupInterruptSystem(&GPS, XPAR_PS7_SCUGIC_0_DEVICE_ID,
         XPAR_FABRIC_PMODGPS_0_GPS_UART_INTERRUPT_INTR);
   GPS_setUpdateRate(&GPS, 1000);

   xil_printf("Init Done\n\r");
}

/* ------------------------------------------------------------ */
/*** DemoRun()
**
**   Parameters:
**      none
**
**   Return Value:
**      none
**
**   Errors:
**      If the demo is shut down without properly exiting, does not reinitialize
**      properly.
**
**   Description:
**      Displays Demo message and each available Fill Pattern.
**      Pauses between runs to check if user wants to continue, if not, exits.
**      To be safe, exit through prompt before closing demo.
**      Requires UART connection to terminal program on PC.
*/
void DemoRun() {
   int irow, ib, i;
   u8 *pat;
   char c;
   xil_printf("UART and SPI opened for PmodOLED Demo\n\r");

   u8 buf[1];
   int n;

   print("Initialized PmodBT2 Demo\n\r");
   print("Received data will be echoed here, type to send data\r\n");

   // Choosing Fill pattern 0
   pat = OLED_GetStdPattern(0);
   OLED_SetFillPattern(&myoled, pat);

   float temp_degc, hum_perrh, temp_degf;

   while (1) {
	  temp_degc = HYGRO_getTemperature(&myHygro);
	  temp_degf = HYGRO_tempC2F(temp_degc);
	  hum_perrh = HYGRO_getHumidity(&myHygro);

      // Echo all characters received from both BT2 and terminal to terminal
      // Forward all characters received from terminal to BT2
      n = SysUart_Recv(&myUart, buf, 1);
      if (n != 0) {
         SysUart_Send(&myUart, buf, 1);
         BT2_SendData(&mybt, buf, 1);
      }

      n = BT2_RecvData(&mybt, buf, 1);
      if (n != 0) {
         SysUart_Send(&myUart, buf, 1);
         OLED_PutChar(&myoled, *buf);
      }


      char tempc[16];
      sprintf(tempc, "TEMP       %d.%dC",(int) temp_degc, ((int) (temp_degc * 10)) % 10);
      char humidity[16];
      sprintf(humidity, "HUMIDITY    %dRH", (int) hum_perrh);

      OLED_SetCursor(&myoled, 0, 1);
      OLED_PutString(&myoled, tempc);
      OLED_SetCursor(&myoled, 0, 2);
      OLED_PutString(&myoled, humidity);
   }

}

void DemoCleanup() {
   OLED_End(&myoled);
   DisableCaches();
}

// Initialize the system UART device
void SysUartInit() {
#ifdef __MICROBLAZE__
   // AXI Uartlite for MicroBlaze
   XUartLite_Initialize(&myUart, SYS_UART_DEVICE_ID);
#else
   // Uartps for Zynq
   XUartPs_Config *myUartCfgPtr;
   myUartCfgPtr = XUartPs_LookupConfig(SYS_UART_DEVICE_ID);
   XUartPs_CfgInitialize(&myUart, myUartCfgPtr, myUartCfgPtr->BaseAddress);
#endif
}

void EnableCaches() {
#ifdef __MICROBLAZE__
#ifdef XPAR_MICROBLAZE_USE_ICACHE
   Xil_ICacheEnable();
#endif
#ifdef XPAR_MICROBLAZE_USE_DCACHE
   Xil_DCacheEnable();
#endif
#endif
}

void DisableCaches() {
#ifdef __MICROBLAZE__
#ifdef XPAR_MICROBLAZE_USE_DCACHE
   Xil_DCacheDisable();
#endif
#ifdef XPAR_MICROBLAZE_USE_ICACHE
   Xil_ICacheDisable();
#endif
#endif
}

int SetupInterruptSystem(PmodGPS *InstancePtr, u32 interruptDeviceID,
      u32 interruptID) {
   int Result;
   u16 Options;

#ifdef XPAR_XINTC_NUM_INSTANCES
   INTC *IntcInstancePtr = &intc;
   /*
    * Initialize the interrupt controller driver so that it's ready to use.
    * specify the device ID that was generated in xparameters.h
    */
   Result = XIntc_Initialize(IntcInstancePtr, interruptDeviceID);
   if (Result != XST_SUCCESS) {
      return Result;
   }

   /* Hook up interrupt service routine */
   XIntc_Connect(IntcInstancePtr, interruptID,
         (Xil_ExceptionHandler) XUartNs550_InterruptHandler,
         &InstancePtr->GPSUart);

   /* Enable the interrupt vector at the interrupt controller */

   XIntc_Enable(IntcInstancePtr, interruptID);

   /*
    * Start the interrupt controller such that interrupts are recognized
    * and handled by the processor
    */
   Result = XIntc_Start(IntcInstancePtr, XIN_REAL_MODE);
   if (Result != XST_SUCCESS) {
      return Result;
   }
   XUartNs550_SetHandler(&InstancePtr->GPSUart, (void*)GPS_intHandler,
         InstancePtr);

   /*
    * Initialize the exception table and register the interrupt
    * controller handler with the exception table
    */
   Xil_ExceptionInit();

   Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
         (Xil_ExceptionHandler)INTC_HANDLER, IntcInstancePtr);

   /* Enable non-critical exceptions */
   Xil_ExceptionEnable();
   Options = XUN_OPTION_DATA_INTR |
   XUN_OPTION_FIFOS_ENABLE;
   XUartNs550_SetOptions(&InstancePtr->GPSUart, Options);

#endif
#ifdef XPAR_SCUGIC_0_DEVICE_ID
   INTC *IntcInstancePtr = &intc;
   XScuGic_Config *IntcConfig;

   /*
    * Initialize the interrupt controller driver so that it is ready to
    * use.
    */
   IntcConfig = XScuGic_LookupConfig(interruptDeviceID);
   if (NULL == IntcConfig) {
      return XST_FAILURE;
   }

   Result = XScuGic_CfgInitialize(IntcInstancePtr, IntcConfig,
         IntcConfig->CpuBaseAddress);
   if (Result != XST_SUCCESS) {
      return XST_FAILURE;
   }

   XScuGic_SetPriorityTriggerType(IntcInstancePtr, interruptID, 0xA0, 0x3);

   /*
    * Connect the interrupt handler that will be called when an
    * interrupt occurs for the device.
    */
   Result = XScuGic_Connect(IntcInstancePtr, interruptID,
         (Xil_ExceptionHandler) XUartNs550_InterruptHandler,
         &InstancePtr->GPSUart);
   if (Result != XST_SUCCESS) {
      return Result;
   }

   /*
    * Enable the interrupt for the GPIO device.
    */
   XScuGic_Enable(IntcInstancePtr, interruptID);

   XUartNs550_SetHandler(&InstancePtr->GPSUart, (void*) GPS_intHandler,
         InstancePtr);

   /*
    * Initialize the exception table and register the interrupt
    * controller handler with the exception table
    */
   Xil_ExceptionInit();

   Xil_ExceptionRegisterHandler(XIL_EXCEPTION_ID_INT,
         (Xil_ExceptionHandler) INTC_HANDLER, IntcInstancePtr);

   /* Enable non-critical exceptions */
   Xil_ExceptionEnable()
   ;

   Options = XUN_OPTION_DATA_INTR | XUN_OPTION_FIFOS_ENABLE;
   XUartNs550_SetOptions(&InstancePtr->GPSUart, Options);
#endif

   return XST_SUCCESS;
}
