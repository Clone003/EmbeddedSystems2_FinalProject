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

/* ------------------------------------------------------------ */
/*                  Definitions                                 */
/* ------------------------------------------------------------ */
#include "xuartps.h"
typedef XUartPs SysUart;
#define SysUart_Send            XUartPs_Send
#define SysUart_Recv            XUartPs_Recv
#define SYS_UART_DEVICE_ID      XPAR_PS7_UART_1_DEVICE_ID
#define BT2_UART_AXI_CLOCK_FREQ 50000000 	//FCLK1

/* ------------------------------------------------------------ */
/*                  Global Variables                            */
/* ------------------------------------------------------------ */

PmodOLED myoled;
PmodBT2 mybt;
SysUart myUart;

/* ------------------------------------------------------------ */
/*                  Forward Declarations                        */
/* ------------------------------------------------------------ */

void DemoInitialize();
void DemoRun();
void SysUartInit();
void DemoCleanup();
void EnableCaches();
void DisableCaches();

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
   //int irow, ib, i;
   //u8 *pat;
   //char c;
   xil_printf("UART and SPI opened for PmodOLED Demo\n\r");

   u8 buf[1];
   int n;

   print("Initialized PmodBT2 Demo\n\r");
   print("Received data will be echoed here, type to send data\r\n");
   while (1) {
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
         OLED_SetCursor(&myoled, 0, 0);
         OLED_PutChar(&myoled, *buf);
      }
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
