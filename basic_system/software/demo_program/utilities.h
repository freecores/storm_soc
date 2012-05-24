#ifndef _UTILITIES_H_
  #define _UTILITIES_H_

// Signals
#define adc_cs 6

// Prototypes
void long_to_hex_string(unsigned long data, unsigned char *buffer, unsigned char numbers);

unsigned int get_adc(int adc_index);

void delay(int time);

#endif // _UTILITIES_H_