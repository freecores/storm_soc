#include "storm_core.h"
#include "storm_soc_de2.h"

// +-------------------------------------------+
// | STORM SoC Bootloader for Altera DE2-Board |
// +-------------------------------------------+


/* ---- Constants ---- */
#define timeout 40000000


/* ---- Function Prototypes ---- */
int uart0_read_byte(void);
int uart0_send_byte(char ch);
const char *uart0_printf(const char *string);
void mem_dump(void);
void jump_app(void);
void program_loader(void);
int main(void);


/* ---- UART0 read byte ---- */
int uart0_read_byte(void)
{
  if ((UART0_SREG & 2) != 0) // byte available?
    return UART0_DATA;
  else
    return -1;
}


/* ---- UART0 write byte ---- */
int uart0_send_byte(char ch)
{
  while((UART0_SREG & 1) == 0); // uart busy?
  ch = ch & 255;
  UART0_DATA = ch;
  return (int)ch;
}


/* ---- UART0 send string ---- */
const char *uart0_printf(const char *string)
{
  char ch;
  while ((ch = *string)) {
    if (uart0_send_byte(ch)<0) break;
    string++;
  }
  return string;
}


/* ---- Memory Dump ---- */
void mem_dump(void)
{
  unsigned long word_buffer;
  unsigned long *data_pointer = 0;

  while(data_pointer != RAM_SIZE)
  {
    word_buffer = *data_pointer;
    uart0_send_byte(word_buffer >> 24);
    uart0_send_byte(word_buffer >> 16);
    uart0_send_byte(word_buffer >>  8);
    uart0_send_byte(word_buffer >>  0);
	data_pointer++;
  }
  while(1)
    asm volatile ("NOP");
}


/* ---- Jump to application ---- */
void jump_app(void)
{
  unsigned long _cp_val;

  SSEG0_CTRL = 0; // deactivate status display
  SSEG1_CTRL = 0; // deactivate counter display

  uart0_printf("\r\nStarting application...\r\n");

  asm volatile ("mrc  p15, 0, %0, c6, c6" : "=r" (_cp_val) : /* no inputs */  );
  _cp_val = _cp_val & ~(1<<3); // disable write-through strategy
  asm volatile ("mcr  p15, 0, %0, c6, c6, 0" : /* no outputs */ : "r" (_cp_val));
 
  asm volatile ("mov PC, #0"); // jump to application
  while(1)
    asm volatile ("NOP");
}


/* ---- Download Program ---- */
void program_loader(void)
{
  int timer, data, shift;
  unsigned long _cp_val;
  unsigned long word_buffer;
  unsigned long *data_pointer;

  uart0_printf("\r\nWaiting for data\r\n");

  SSEG0_CTRL = 118963166; // show 'LoAd' screen
  SSEG1_CTRL = 0; // deactivate counter display

  data_pointer = 0; // beginning of RAM
  shift = 32;
  word_buffer = 0;
  timer = timeout;
  while(timer != 0) // timer loop
  {
    data = uart0_read_byte();
    if(data == -1)
	  timer--;
	else // byte received
    {
      // reset timer
	  timer = timeout;
	  // construct 32-bit memory entry
      shift = shift - 8;
	  word_buffer = word_buffer | (data << shift);
	  if(shift == 0) // word completed
	  {
	    // store memory entry
		*data_pointer = word_buffer;
		data_pointer = data_pointer + 1;
		word_buffer = 0;
		shift = 32;
	  }
	}
  }
  jump_app();
}


/* ---- Main function ---- */
int main(void)
{
  int timer, data;
  unsigned long _cp_val;
  unsigned long *data_pointer;

  SSEG0_CTRL = 261566072; // show 'boot' screen
  SSEG1_CTRL = 0; // clear counter display

  // enable write-through -> flush-cache required
  asm volatile (" mrc  p15, 0, %0, c6, c6" : "=r" (_cp_val) : /* no inputs */  );
//_cp_val = _cp_val | (1<<0) | (1<<3);
  _cp_val = _cp_val | (1<<3);
  asm volatile (" mcr  p15, 0, %0, c6, c6, 0" : /* no outputs */ : "r" (_cp_val));

  // configure external memory controller
  XMC_CSR = 0x0B000600; // refresh prescaler || refresh interval
  XMC_BA_MASK = 255;
  // Trfc, Trp, Trcd, Twr, Burst length = pog, opmode, cas lat = 2, burst type = seq, burst length = 8
  XMC_TMS0 = 0x04138023; // = (4<<24) || (1<<20) || (1<<17) || (4<<15) || (0<<9) || (0<<7) || (2<<4) || (0<<3) || (3<<0);
  // Base addr, no parity, row open, bank-col addr , wp = 0, size = ?, b_width = 16, type = sdram, en
  XMC_CSC0 = 0x00000411; // = (0<<16) || (0<<11) || (1<<10) || (0<<9) || (0<<8) || (0<<6) || (1<<4) || (0<<1) || (1<<0);

  uart0_printf("\r\nSTORM Core Processor System - by Stephan Nolting\r\n");
  uart0_printf("Bootloader for STORM SoC on Altera DE2-Board\r\n");
  uart0_printf("Version: 19.03.2012\r\n");

  uart0_printf("\r\n0: RAM dump\r\n");
  uart0_printf("1: Load via UART\r\n");
  uart0_printf("x: Jump to application\r\n");
  uart0_printf("\r\nSelect: ");

  timer = timeout;
  while(timer != 0)
  {
	data = uart0_read_byte();
    if(data == '1')      // start program downloader
	{
	  uart0_send_byte((char)data);
	  program_loader();
	}
	else if((data == 'x') || ((GPIO0_IN & (1<<16)) == 0)) // start application
	{
	  uart0_send_byte((char)data);
	  break;
	}
	else if(data == '0') // print memory content
	{
	  uart0_send_byte((char)data);
	  mem_dump();
	}
	else
	  timer--;
	SSEG1_DATA = timer >> 18;
  }
  jump_app();
}
