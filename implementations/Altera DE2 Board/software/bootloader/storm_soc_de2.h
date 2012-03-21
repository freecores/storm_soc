#ifndef storm_soc_h
#define storm_soc_h

/////////////////////////////////////////////////////////////////
// storm_soc_de2.h - STORM SoC for Altera DE2-Board
// Based on the STORM Core Processor System
//
// Created by Stephan Nolting (stnolting@googlemail.com)
// http://www.opencores.com/project,storm_core
// http://www.opencores.com/project,storm_soc
// Last modified 07. Mar. 2012
/////////////////////////////////////////////////////////////////

#define REG32 (volatile unsigned int*)

/* Internal RAM */
#define IRAM_BASE       (*(REG32 (0x00000000)))
#define IRAM_SIZE       8*1024

/* External RAM */
#define XRAM_BASE       (*(REG32 (0x00002000)))
#define XRAM_SIZE       8*1024*1024

/* Complete RAM */
#define RAM_BASE        (*(REG32 (0x00000000)))
#define RAM_SIZE        IRAM_SIZE+XRAM_SIZE

/* Internal ROM (boot ROM) */
#define ROM_BASE        (*(REG32 (0xFFF00000)))
#define ROM_SIZE        2*1024

/* De-Cached IO Area */
#define IO_AREA_BEGIN   (*(REG32 (0xFFFF0000)))
#define IO_AREA_END     (*(REG32 (0xFFFFFFFF)))
#define IO_AREA_SIZE    524288;

/*  General Purpose IO Controller 0 */
#define GPIO0_BASE      (*(REG32 (0xFFFF0000)))
#define GPIO0_SIZE      2*4
#define GPIO0_OUT       (*(REG32 (0xFFFF0000)))
#define GPIO0_IN        (*(REG32 (0xFFFF0004)))

/* Seven Segment Controller 0 */
#define SSEG0_BASE      (*(REG32 (0xFFFF0008)))
#define SSEG0_SIZE      2*4
#define SSEG0_DATA      (*(REG32 (0xFFFF0008)))
#define SSEG0_CTRL      (*(REG32 (0xFFFF000C)))

/* Seven Segment Controller 1 */
#define SSEG1_BASE      (*(REG32 (0xFFFF0010)))
#define SSEG1_SIZE      2*4
#define SSEG1_DATA      (*(REG32 (0xFFFF0010)))
#define SSEG1_CTRL      (*(REG32 (0xFFFF0014)))

/* UART 0 - miniUART */
#define UART0_BASE      (*(REG32 (0xFFFF0018)))
#define UART0_SIZE      2*4
#define UART0_DATA      (*(REG32 (0xFFFF0018)))
#define UART0_SREG      (*(REG32 (0xFFFF001C)))

/* System Timer 0 */
#define STME0_BASE      (*(REG32 (0xFFFF0020)))
#define STME0_SIZE      4*4
#define STME0_CNT       (*(REG32 (0xFFFF0020)))
#define STME0_VAL       (*(REG32 (0xFFFF0024)))
#define STME0_CONF      (*(REG32 (0xFFFF0028)))
#define STME0_SCRT      (*(REG32 (0xFFFF002C)))

/* SPI 0 */
#define SPI0_BASE       (*(REG32 (0xFFFF0030)))
#define SPI0_SIZE       8*4
#define SPI0_CONF       (*(REG32 (0xFFFF0030)))
#define SPI0_PRSC       (*(REG32 (0xFFFF0034)))
#define SPI0_SCSR       (*(REG32 (0xFFFF0038)))
// unused location      (*(REG32 (0xFFFF003C)))
#define SPI0_DAT0       (*(REG32 (0xFFFF0040)))
#define SPI0_DAT1       (*(REG32 (0xFFFF0044)))
#define SPI0_DAT2       (*(REG32 (0xFFFF0048)))
#define SPI0_DAT3       (*(REG32 (0xFFFF004C)))

/* I²C 0 */
#define I2C0_BASE       (*(REG32 (0xFFFF0050)))
#define I2C0_SIZE       8*4
#define I2C0_CMD        (*(REG32 (0xFFFF0050)))
#define I2C0_STAT       (*(REG32 (0xFFFF0050)))
// unused location      (*(REG32 (0xFFFF0054)))
// unused location      (*(REG32 (0xFFFF0058)))
// unused location      (*(REG32 (0xFFFF005C)))
#define I2C0_PRLO       (*(REG32 (0xFFFF0060)))
#define I2C0_PRHI       (*(REG32 (0xFFFF0064)))
#define I2C0_CTRL       (*(REG32 (0xFFFF0068)))
#define I2C0_DATA       (*(REG32 (0xFFFF006C)))

/* Ps2 Interface */
#define PS2_BASE        (*(REG32 (0xFFFF0070)))
#define PS2_SIZE        2*4
#define PS2_DATA        (*(REG32 (0xFFFF0070)))
#define PS2_STAT        (*(REG32 (0xFFFF0074)))

/* External Memory CTRL */
#define XMC_BASE        (*(REG32 (0xFFFFEF00)))
#define XMC_SIZE        20*4
#define XMC_CSR         (*(REG32 (0xFFFFEF00)))
#define XMC_POC         (*(REG32 (0xFFFFEF04)))
#define XMC_BA_MASK     (*(REG32 (0xFFFFEF08)))
// unused location      (*(REG32 (0xFFFFEF0C)))
#define XMC_CSC0        (*(REG32 (0xFFFFEF10)))
#define XMC_TMS0        (*(REG32 (0xFFFFEF14)))
#define XMC_CSC1        (*(REG32 (0xFFFFEF18)))
#define XMC_TMS1        (*(REG32 (0xFFFFEF1C)))
#define XMC_CSC2        (*(REG32 (0xFFFFEF20)))
#define XMC_TMS2        (*(REG32 (0xFFFFEF24)))
#define XMC_CSC3        (*(REG32 (0xFFFFEF28)))
#define XMC_TMS3        (*(REG32 (0xFFFFEF2C)))
#define XMC_CSC4        (*(REG32 (0xFFFFEF30)))
#define XMC_TMS4        (*(REG32 (0xFFFFEF34)))
#define XMC_CSC5        (*(REG32 (0xFFFFEF38)))
#define XMC_TMS5        (*(REG32 (0xFFFFEF3C)))
#define XMC_CSC6        (*(REG32 (0xFFFFEF40)))
#define XMC_TMS6        (*(REG32 (0xFFFFEF44)))
#define XMC_CSC7        (*(REG32 (0xFFFFEF48)))
#define XMC_TMS7        (*(REG32 (0xFFFFEF4C)))

/* Vector Interrupt Controller */
#define VIC_BASE        (*(REG32 (0xFFFFF000)))
#define VIC_SIZE        64*4
#define VICIRQStatus    (*(REG32 (0xFFFFF000)))
#define VICFIQStatus    (*(REG32 (0xFFFFF004)))
#define VICRawIntr      (*(REG32 (0xFFFFF008)))
#define VICIntSelect    (*(REG32 (0xFFFFF00C)))
#define VICIntEnable    (*(REG32 (0xFFFFF010)))
#define VICIntEnClear   (*(REG32 (0xFFFFF014)))
#define VICSoftInt      (*(REG32 (0xFFFFF018)))
#define VICSoftIntClear (*(REG32 (0xFFFFF01C)))
#define VICProtection   (*(REG32 (0xFFFFF020)))
#define VICVectAddr     (*(REG32 (0xFFFFF030)))
#define VICDefVectAddr  (*(REG32 (0xFFFFF034)))
#define VICTrigLevel    (*(REG32 (0xFFFFF038)))
#define VICTrigMode     (*(REG32 (0xFFFFF03C)))
#define VICVectAddr0    (*(REG32 (0xFFFFF040)))
#define VICVectAddr1    (*(REG32 (0xFFFFF044)))
#define VICVectAddr2    (*(REG32 (0xFFFFF048)))
#define VICVectAddr3    (*(REG32 (0xFFFFF04C)))
#define VICVectAddr4    (*(REG32 (0xFFFFF050)))
#define VICVectAddr5    (*(REG32 (0xFFFFF054)))
#define VICVectAddr6    (*(REG32 (0xFFFFF058)))
#define VICVectAddr7    (*(REG32 (0xFFFFF05C)))
#define VICVectAddr8    (*(REG32 (0xFFFFF060)))
#define VICVectAddr9    (*(REG32 (0xFFFFF064)))
#define VICVectAddr10   (*(REG32 (0xFFFFF068)))
#define VICVectAddr11   (*(REG32 (0xFFFFF06C)))
#define VICVectAddr12   (*(REG32 (0xFFFFF070)))
#define VICVectAddr13   (*(REG32 (0xFFFFF074)))
#define VICVectAddr14   (*(REG32 (0xFFFFF078)))
#define VICVectAddr15   (*(REG32 (0xFFFFF07C)))
#define VICVectCntl0    (*(REG32 (0xFFFFF080)))
#define VICVectCntl1    (*(REG32 (0xFFFFF084)))
#define VICVectCntl2    (*(REG32 (0xFFFFF088)))
#define VICVectCntl3    (*(REG32 (0xFFFFF08C)))
#define VICVectCntl4    (*(REG32 (0xFFFFF090)))
#define VICVectCntl5    (*(REG32 (0xFFFFF094)))
#define VICVectCntl6    (*(REG32 (0xFFFFF098)))
#define VICVectCntl7    (*(REG32 (0xFFFFF09C)))
#define VICVectCntl8    (*(REG32 (0xFFFFF0A0)))
#define VICVectCntl9    (*(REG32 (0xFFFFF0A4)))
#define VICVectCntl10   (*(REG32 (0xFFFFF0A8)))
#define VICVectCntl11   (*(REG32 (0xFFFFF0AC)))
#define VICVectCntl12   (*(REG32 (0xFFFFF0B0)))
#define VICVectCntl13   (*(REG32 (0xFFFFF0B4)))
#define VICVectCntl14   (*(REG32 (0xFFFFF0B8)))
#define VICVectCntl15   (*(REG32 (0xFFFFF0BC)))

#endif // storm_soc_h
