#include "storm_core.h"
#include "storm_soc_de2.h"

// +--------------------------+
// | STORM SoC DE2-Board Demo |
// +--------------------------+


/* ---- IRQ: Timer ISR ---- */
volatile unsigned long timeval;
void __attribute__ ((interrupt("IRQ"))) timer0_isr(void);
void timer0_isr(void)
{
  timeval++;
  SSEG0_DATA = timeval;
  VICVectAddr = 0;
}


/* ---- SPI 0 Transmission ---- */
void spi0_send_byte(int data, int slave_id)
{
  while((SPI0_CONF & (1<<8)) != 0); // spi busy?
  SPI0_DAT0 = data;
  SPI0_SCSR = ~slave_id & 255;
  SPI0_CONF = SPI0_CONF | 256;
}


/* ---- UART0 read byte ---- */
int uart0_read_byte(void)
{
  if ((UART0_SREG & (1<<1)) != 0) // byte available?
    return UART0_DATA;
  else
    return -1;
}


/* ---- UART0 write byte ---- */
int uart0_send_byte(char ch)
{
  while((UART0_SREG & (1<<0)) == 0); // uart busy?
  ch = ch & 255;
  UART0_DATA = ch;
  return (int)ch;
}


/* ---- I2C0 write byte ---- */
int i2c0_send_byte(char adr, int data)
{
  I2C0_CMD  = (1<<7) | (1<<4); // start condition
  while((I2C0_STAT & (1<<1)) != 0);  // wait for execution

  I2C0_DATA = adr;
  I2C0_CMD  = (1<<4); // write to slave
  while((I2C0_STAT & (1<<7)) != 0); // wait for ack

  I2C0_DATA = data;
  I2C0_CMD  = (1<<4); // write to slave
  while((I2C0_STAT & (1<<7)) != 0); // wait for ack

  I2C0_CMD  = (1<<6); // stop condition
  while((I2C0_STAT & (1<<1)) != 0);  // wait for execution
  return data;
}


/* ---- Enable IRQ ---- */
void enable_irq(void)
{
  unsigned long _cpsr;
  asm volatile (" mrs  %0, cpsr" : "=r" (_cpsr) : /* no inputs */  );
  _cpsr = _cpsr & ~(1<<7);
  asm volatile (" msr  cpsr, %0" : /* no outputs */ : "r" (_cpsr)  );
}


/* ---- Disable IRQ ---- */
void disable_irq(void)
{
  unsigned long _cpsr;
  asm volatile (" mrs  %0, cpsr" : "=r" (_cpsr) : /* no inputs */  );
  _cpsr = _cpsr | (1<<7);
  asm volatile (" msr  cpsr, %0" : /* no outputs */ : "r" (_cpsr)  );
}


/* ---- Delay function ---- */
void delay(int delay)
{
  int i;
  for(i=0; i<delay*10000; i++)
    asm volatile ("NOP");
}


/* ---- Main function ---- */
int main(void)
{
  int led_timer;
  int data;

  // display clear
  SSEG1_DATA = 0;
  SSEG0_DATA = 0;

  // SPI 0 init
  led_timer  = 0;
  SPI0_CONF  = (1<<10) | (1<<9) | 8;
  SPI0_PRSC  = 500; // 100kHz
  spi0_send_byte(0, 255);
  spi0_send_byte(0, 255);

  // I²C 0 init
  I2C0_PRLO  = 99; // for 100kHz
  I2C0_PRHI  = 0;
  I2C0_CTRL  = (1<<7); // i2c enable

  // timer init
  timeval    = 0;
  STME0_CNT  = 0;
  STME0_VAL  = 50000000; // threshold value for 1s ticks
  STME0_CONF = (1<<2) | (1<<1) | (1<<0); // interrupt en, auto reset, timer enable
  VICVectAddr0 = (unsigned long)timer0_isr;
  VICVectCntl0 = (1<<5) | 0; // enable and channel select = 0 (timer0)
  VICIntEnable = (1<<0); // enable channel 0 (timer0)
  
  //i2c0_send_byte(56, 0xCC);

  enable_irq();

  while(1)
  {
    //disable_irq();
    data = uart0_read_byte();
    if(data > -1)
    {
      spi0_send_byte(data, 255);
      uart0_send_byte(data);
    }
    if((PS2_STAT & (1<<1)) != 0) // char available?
    {
	  PS2_STAT = 0; // ack
	  data = PS2_DATA;
      spi0_send_byte(data, 255);
      uart0_send_byte(data);
    }
    //enable_irq();
	led_timer++;
	GPIO0_OUT = led_timer >> 16;
  }
}
