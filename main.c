/******************************************************************************/
/*                                                                            */
/* Embedded Systems II Final Project			                              */
/* Author - John Reiner Sloan												  */
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
#define BT2_UART_AXI_CLOCK_FREQ 50000000 	//FCLK0

#define TIMER_FREQ_HZ 50000000 //FCLK? for hygro

#define PERIPHERAL_CLK 50000000 // FCLK0 frequency is not in xparameters.h for some reason

#include "xscugic.h"
#define INTC         XScuGic
#define INTC_HANDLER XScuGic_InterruptHandler

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
//void EnableCaches();
//void DisableCaches();

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
   //EnableCaches();
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

void DemoRun() {
   u8 *pat;
   xil_printf("UART and SPI opened for PmodOLED Demo\n\r");

   u8 buf[1];
   int n;

   print("Initialized PmodBT2 Demo\n\r");
   print("Received data will be echoed here, type to send data\r\n");

   // Choosing Fill pattern 0
   pat = OLED_GetStdPattern(0);
   OLED_SetFillPattern(&myoled, pat);
   // Turn automatic updating off
   OLED_SetCharUpdate(&myoled, 0);

   float temp_degc, hum_perrh, temp_degf;
   char lat[16], lon[16], alt[16], numsats[16] = "";
   char line[5] = "";

   while (1) {
	  //hygrometer
	  temp_degc = HYGRO_getTemperature(&myHygro);
	  temp_degf = temp_degc * 9 / 5 + 32;
	  hum_perrh = HYGRO_getHumidity(&myHygro);
      /*xil_printf(
         "Temperature: %d.%02d deg F  Humidity: %d.%02d RH\n\r",
         (int) temp_degf,
         ((int) (temp_degf * 100)) % 100,
         (int) hum_perrh,
         ((int) (hum_perrh * 100)) % 100
      );*/

      char tempc[16];
      sprintf(tempc, "%d.%dC",(int) temp_degc, ((int) (temp_degc * 10)) % 10);
      char tempf[16];
      sprintf(tempf, "%d.%dF",(int) temp_degf, ((int) (temp_degf * 10)) % 10);
      char humidity[16];
      sprintf(humidity, "%dRH", (int) hum_perrh);

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
         if ( *buf == 'e' ) {

        	 OLED_ClearBuffer(&myoled);
             OLED_SetCursor(&myoled, 0, 0);
             OLED_PutString(&myoled, "Editing");
             OLED_SetCursor(&myoled, 0, 1);
             OLED_Update(&myoled);

             int i = 1;
        	 while (i <= 4) {
        		 n = BT2_RecvData(&mybt, buf, 1);
        	     if (n != 0) {
        	    	 SysUart_Send(&myUart, buf, 1);
        	    	 line[i] = *buf;
                     OLED_PutChar(&myoled, *buf);
        	    	 i++;
        	     }
        	     OLED_Update(&myoled);
        	 }

         }
      }

      if (GPS.ping) { //GPS
         GPS_formatSentence(&GPS);
         if (GPS_isFixed(&GPS)) {
        	 /*
            xil_printf("Latitude: %s\n\r", GPS_getLatitude(&GPS));
            xil_printf("Longitude: %s\n\r", GPS_getLongitude(&GPS));
            xil_printf("Altitude: %s\n\r", GPS_getAltitudeString(&GPS));
            xil_printf("Number of Satellites: %d\n\n\r", GPS_getNumSats(&GPS));*/
            sprintf(lat, "%s", GPS_getLatitude(&GPS));
            sprintf(lon, "%s", GPS_getLongitude(&GPS));
            sprintf(alt, "%s", GPS_getAltitudeString(&GPS));
            sprintf(numsats, "%2d", GPS_getNumSats(&GPS));
            lat[2] = 32;
            lon[2] = 32;
         } else {
            xil_printf("Number of Satellites: %d\n\r", GPS_getNumSats(&GPS));
            sprintf(numsats, "%2d", (int) GPS_getNumSats(&GPS));
         }
         GPS.ping = FALSE;
      }

      OLED_ClearBuffer(&myoled);
      for (int i = 0; i < 4; i++) {
          OLED_SetCursor(&myoled, 0,i);

          switch(line[i+1]) {
          case 'c':
        	  OLED_PutString(&myoled, "Temp       ");
        	  OLED_PutString(&myoled, tempc);
        	  break;
          case 'f':
        	  OLED_PutString(&myoled, "Temp       ");
        	  OLED_PutString(&myoled, tempf);
        	  break;
          case 'r':
        	  OLED_PutString(&myoled, "Humidity    ");
        	  OLED_PutString(&myoled, humidity);
        	  break;
          case 'a':
        	  OLED_PutString(&myoled, "Lat ");
        	  OLED_PutString(&myoled, lat);
        	  break;
          case 'o':
        	  OLED_PutString(&myoled, "Lon ");
        	  OLED_PutString(&myoled, lon);
        	  break;
          case 'h':
        	  OLED_PutString(&myoled, "Altitude  ");
        	  OLED_PutString(&myoled, alt);
        	  break;
          case 's':
        	  OLED_PutString(&myoled, "Satellites    ");
        	  OLED_PutString(&myoled, numsats);
        	  break;
          default:
        	  OLED_PutString(&myoled, "Error: ");
        	  OLED_PutChar(&myoled, line[i+1]);
        	  break;
          }
      }
      OLED_Update(&myoled);
   }

}

void DemoCleanup() {
   OLED_End(&myoled);
   //DisableCaches();
}

// Initialize the system UART device
void SysUartInit() {
   // Uartps for Zynq
   XUartPs_Config *myUartCfgPtr;
   myUartCfgPtr = XUartPs_LookupConfig(SYS_UART_DEVICE_ID);
   XUartPs_CfgInitialize(&myUart, myUartCfgPtr, myUartCfgPtr->BaseAddress);
}
/*
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
}*/

int SetupInterruptSystem(PmodGPS *InstancePtr, u32 interruptDeviceID,
      u32 interruptID) {
   int Result;
   u16 Options;


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

   return XST_SUCCESS;
}
