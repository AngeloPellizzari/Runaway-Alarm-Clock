#include  "msp430.h"
#define   EN12    BIT1
#define   A1EN    BIT1
#define   A2EN    BIT2
#define   TRGR    BIT4                      //TRGR on P1.4, output (1)
#define   ECHO    BIT5                      //ECHO on P1.5, input (0)
#define   EN34    BIT2
#define   A3EN    BIT6
#define   A4EN    BIT7
#define   BEEP    BIT0
#define   FWRD    (A1EN + A2EN)
#define   RVRS    (A3EN + A4EN) 
#define   RGHT    (A2EN + A4EN)
#define   LEFT    (A1EN + A3EN)

void configureClock(void);
void configureSensorChannels(void);
void configurePins(void);

unsigned int hour = 6;
unsigned int min = 29;
unsigned int sec = 55;
unsigned int ms = 0;
unsigned int us = 0;
//unsigned int TXByte;
unsigned int timeMeasured = 0;
unsigned int state = 0;
unsigned int dist = 0;

void main(void)
{
    WDTCTL = WDTPW + WDTHOLD;                 // Stop WDT
    configureClock();
    configurePins();
    while(1){
        us +=1;
        if(us == 15){
            ms += 1;
            us -= 33;
        }
        if(ms == 1000){
            sec += 1;
            ms -= 1000;
        }
        if(sec == 60){
            min += 1;
            sec -= 60;
        }
        if(min > 60){
            hour +=1;
            min -= 60;
        }
        if(hour > 24){
            hour -= 24;
        }
        if(hour == 6 && min == 30 && sec == 0){
            state = 1;
            P1OUT |= FWRD;
            //P1OUT |= BEEP;
            while(state == 1){
                P2OUT |= BIT4;
                P1SEL |= BEEP;
                TACCR0 = 1000;
                TACCTL1 = OUTMOD_7;
                TACCR1 = 70;
                TACTL = TASSEL_2 + MC_1;
                //_BIS_SR(LPM0_bits);
                //P1OUT |= BEEP;
                P1OUT |= TRGR;
                __delay_cycles(10);
                P1OUT &= ~TRGR;
                while(P1IN < ECHO){
                us += 1;
                }
                //timeMeasured = 0;
                TA1R = 0;
                while(P1IN >= 32){
                us += 1;
                //timeMeasured +=1;
                }
                timeMeasured = TA1R;
                dist = timeMeasured / 58;
                if(dist < 15){
                    P1OUT &= ~FWRD;
                    P1OUT |= RGHT;
                    __delay_cycles(2000000);
                    sec +=2;
                    P1OUT &= ~RGHT;
                    P1OUT |= FWRD;
                }
                __delay_cycles(100000);
                ms += 100;
                //P1OUT &= ~BEEP;
           }
        }
    }
}

/*
  while(1) {
    P1OUT |= TRGR;
    __delay_cycles(10);  			//1MHz ~ 1 000 000 cycles/s, so this is ~ 10us
    P1OUT &= ~TRGR;
    // Stuff
    while(P1IN == 6);
    TAR = 0;
    while(P1IN != 6);
    timeMeasured = TAR;
    TXByte = timeMeasured / 58;
    while (! (IFG2 & UCA0TXIFG)); 		// wait for TX buffer to be ready for new data
    UCA0TXBUF = TXByte;
    __delay_cycles(100000);
    }
*/


void configureSensorChannels(void) {
    P1DIR |= TRGR;          			// setting up output direction (1) on trigger
    P1DIR &= ~ECHO;
}


void configureClock(void){
    /* next three lines to use internal calibrated 1MHz clock: */
    //BCSCTL1 = CALBC1_1MHZ;                    	// Set range
    //DCOCTL = CALDCO_1MHZ;
    //BCSCTL2 &= ~(DIVS_3);                     	// SMCLK = DCO = 1MHz
    //TACTL = TACLR;				//Clear timer A0
    //TA1CTL = 0;					//Clear timer A1
    //TACCR0 = 1000;				//Set period for A0
    //TA1CCR0 = 1000;				//Set period for A1
    //TACTL = TASSEL_2 + MC_1;			//Set path for A0 to system clock up mode
    //TA1CTL = TASSEL_2 + MC_1;			//Set path for A1 to system clock up mode
    //TACCTL1 = CCIE;				//Set interrupt on A0
    //TA1CCTL1 = CCIE;				//Set interrupt on A1
    //TAR = 0;
    //TA1R = 0;
    
}

void configurePins(void){
    P1DIR &= ~BIT3;
    P1DIR |= (BEEP + A1EN + A2EN + A3EN + A4EN);
    P2DIR |= (EN12 + EN34 + BIT4);
    P1OUT = BIT3;
    P2OUT = (EN12 + EN34);
    P1REN = BIT3;
    P1IFG &= ~BIT3;
    P1IES |= BIT3;
    P1IE  = BIT3;
    __enable_interrupt();
}

// Port 1 button interrupt
// Used to turn off the car when the "snooze button" is hit
void __attribute__ ((interrupt(PORT1_VECTOR))) PORT1_ISR(void){
    P1OUT = BIT3;
    P2OUT = EN12 + EN34;
    state = 0;
    P1SEL &= ~BEEP;
    P1IFG &= ~BIT3;
}
