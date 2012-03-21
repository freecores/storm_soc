-- #######################################################
-- #     < STORM System on Chip by Stephan Nolting >     #
-- # *************************************************** #
-- #                 STORM SoC TESTBENCH                 #
-- # *************************************************** #
-- # Version 1.0, 06.03.2012                             #
-- #######################################################

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity STORM_SoC_DE2_TB is
end STORM_SoC_DE2_TB;

architecture Structure of STORM_SoC_DE2_TB is

	-- Global signals ----------------------------------------------------
	-- ----------------------------------------------------------------------
		signal CLK, RST      : STD_LOGIC := '1';
		signal SCL, SDA      : STD_LOGIC;

	-- STORM SoC TOP ENTITY ----------------------------------------------
	-- ----------------------------------------------------------------------
		component STORM_SoC_DE2
		port (
				-- Global Control --
				CLK_I         : in    STD_LOGIC;
				RST_I         : in    STD_LOGIC;

				-- General purpose UART --
				UART0_RXD_I   : in    STD_LOGIC;
				UART0_TXD_O   : out   STD_LOGIC;

				-- General purpose IO --
				GP_IO_PORT_O  : out   STD_LOGIC_VECTOR(15 downto 0);
				GP_IO_PORT_I  : in    STD_LOGIC_VECTOR(18 downto 0);

				-- Status Lights --
				LED_IT_O      : out   STD_LOGIC;
				LED_DT_O      : out   STD_LOGIC;
				LED_IO_O      : out   STD_LOGIC;

				-- I²C Connection --
				I2C_SCL_IO    : inout STD_LOGIC;
				I2C_SDA_IO    : inout STD_LOGIC;

				-- Keyboard Connection --
				PS2_CLK_IO    : inout STD_LOGIC;
				PS2_DAT_IO    : inout STD_LOGIC;

				-- SPI Connection --
				SPI_CLK_O     : out   STD_LOGIC;
				SPI_MISO_I    : in    STD_LOGIC;
				SPI_MOSI_O    : out   STD_LOGIC;
				SPI_SS_O      : out   STD_LOGIC_VECTOR(07 downto 0);

				-- Seven Segment Control --
				HEX_O         : out   STD_LOGIC_VECTOR(55 downto 0);

				-- SDRAM Interface --
				SDRAM_CLK_O   : out   STD_LOGIC;
				SDRAM_CSN_O   : out   STD_LOGIC;
				SDRAM_CKE_O   : out   STD_LOGIC;
				SDRAM_RASN_O  : out   STD_LOGIC;
				SDRAM_CASN_O  : out   STD_LOGIC;
				SDRAM_WEN_O   : out   STD_LOGIC;
				SDRAM_DQM_O   : out   STD_LOGIC_VECTOR(01 downto 0);
				SDRAM_BA_O    : out   STD_LOGIC_VECTOR(01 downto 0);
				SDRAM_ADR_O   : out   STD_LOGIC_VECTOR(11 downto 0);
				SDRAM_DAT_IO  : inout STD_LOGIC_VECTOR(15 downto 0)
			 );
		end component;


begin

	-- Clock/Reset Generator ---------------------------------------------
	-- ----------------------------------------------------------------------
		CLK <= not CLK after 10 ns;
		RST <= '0', '1' after 200 ns;



	-- STORM SoC TOP ENTITY -------------------------------------------
	-- ----------------------------------------------------------------------
		UUT: STORM_SoC_DE2
		port map (
					-- Global Control --
					CLK_I         => CLK,
					RST_I         => RST,

					-- General purpose UART --
					UART0_RXD_I   => '1',
					UART0_TXD_O   => open,

					-- General Purspose IO --
					GP_IO_PORT_O  => open,
					GP_IO_PORT_I  => "0000000000000000000",

					-- Status Lights --
					LED_IT_O      => open,
					LED_DT_O      => open,
					LED_IO_O      => open,

					-- I²C Connection --
					I2C_SCL_IO    => open,
					I2C_SDA_IO    => open,

					-- Keyboard Connection --
					PS2_CLK_IO    => SCL,
					PS2_DAT_IO    => SDA,

					-- SPI Connection --
					SPI_CLK_O     => open,
					SPI_MISO_I    => '0',
					SPI_MOSI_O    => open,
					SPI_SS_O      => open,

					-- Seven Segment Control --
					HEX_O         => open,

					-- SDRAM Interface --
					SDRAM_CLK_O   => open,
					SDRAM_CSN_O   => open,
					SDRAM_CKE_O   => open,
					SDRAM_RASN_O  => open,
					SDRAM_CASN_O  => open,
					SDRAM_WEN_O   => open,
					SDRAM_DQM_O   => open,
					SDRAM_BA_O    => open,
					SDRAM_ADR_O   => open,
					SDRAM_DAT_IO  => open
				);
		
		SCL <= 'H';
		SDA <= 'H';



end Structure;