-- ######################################################
-- #          < STORM SoC by Stephan Nolting >          #
-- # ************************************************** #
-- #             -- Internal ROM Memory --              #
-- #      Can be initialized with bootloader image      #
-- # ************************************************** #
-- #  Currently supported FPGA boards:                  #
-- #    - Altera/Terasic DE2-Board                      #
-- # ************************************************** #
-- # Last modified: 08.03.2012                          #
-- ######################################################

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

library work;
use work.STORM_core_package.all;

entity BOOT_ROM_FILE is
	generic	(
				MEM_SIZE      : natural := 1024;  -- memory cells
				LOG2_MEM_SIZE : natural := 10;    -- log2(memory cells)
				OUTPUT_GATE   : boolean := FALSE; -- use output gate
				INIT_IMAGE_ID : string  := "-"    -- init image
			);
	port	(
				-- Wishbone Bus --
				WB_CLK_I      : in  STD_LOGIC; -- memory master clock
				WB_RST_I      : in  STD_LOGIC; -- high active sync reset
				WB_CTI_I      : in  STD_LOGIC_VECTOR(02 downto 0); -- cycle indentifier
				WB_TGC_I      : in  STD_LOGIC_VECTOR(06 downto 0); -- cycle tag
				WB_ADR_I      : in  STD_LOGIC_VECTOR(LOG2_MEM_SIZE-1 downto 0); -- adr in
				WB_DATA_I     : in  STD_LOGIC_VECTOR(31 downto 0); -- write data
				WB_DATA_O     : out STD_LOGIC_VECTOR(31 downto 0); -- read data
				WB_SEL_I      : in  STD_LOGIC_VECTOR(03 downto 0); -- data quantity
				WB_WE_I       : in  STD_LOGIC; -- write enable
				WB_STB_I      : in  STD_LOGIC; -- valid cycle
				WB_ACK_O      : out STD_LOGIC; -- acknowledge
				WB_HALT_O     : out STD_LOGIC; -- throttle master
				WB_ERR_O      : out STD_LOGIC  -- abnormal cycle termination
			);
end BOOT_ROM_FILE;

architecture Behavioral of BOOT_ROM_FILE is

	--- Internal signals ---
	signal WB_ACK_O_INT : STD_LOGIC;
	signal WB_DATA_INT  : STD_LOGIC_VECTOR(31 downto 0);

	--- ROM Type ---
	type BOOT_ROM_TYPE is array (0 to MEM_SIZE - 1) of STD_LOGIC_VECTOR(31 downto 0);

	--- Altera DE2-Board Bootloader Image -------------------------
	constant DE2_BOOTLOADER_IMAGE : BOOT_ROM_TYPE :=
	(
000000 => x"EA000012",
000001 => x"E59FF014",
000002 => x"E59FF014",
000003 => x"E59FF014",
000004 => x"E59FF014",
000005 => x"E1A00000",
000006 => x"E51FFFF0",
000007 => x"E59FF010",
000008 => x"FFF00038",
000009 => x"FFF0003C",
000010 => x"FFF00040",
000011 => x"FFF00044",
000012 => x"FFF00048",
000013 => x"FFF0004C",
000014 => x"EAFFFFFE",
000015 => x"EAFFFFFE",
000016 => x"EAFFFFFE",
000017 => x"EAFFFFFE",
000018 => x"EAFFFFFE",
000019 => x"EAFFFFFE",
000020 => x"E59F00E8",
000021 => x"E10F1000",
000022 => x"E3C1107F",
000023 => x"E38110DB",
000024 => x"E129F001",
000025 => x"E1A0D000",
000026 => x"E2400080",
000027 => x"E10F1000",
000028 => x"E3C1107F",
000029 => x"E38110D7",
000030 => x"E129F001",
000031 => x"E1A0D000",
000032 => x"E2400080",
000033 => x"E10F1000",
000034 => x"E3C1107F",
000035 => x"E38110D1",
000036 => x"E129F001",
000037 => x"E1A0D000",
000038 => x"E2400080",
000039 => x"E10F1000",
000040 => x"E3C1107F",
000041 => x"E38110D2",
000042 => x"E129F001",
000043 => x"E1A0D000",
000044 => x"E2400080",
000045 => x"E10F1000",
000046 => x"E3C1107F",
000047 => x"E38110D3",
000048 => x"E129F001",
000049 => x"E1A0D000",
000050 => x"E2400080",
000051 => x"E10F1000",
000052 => x"E3C1107F",
000053 => x"E38110DF",
000054 => x"E129F001",
000055 => x"E1A0D000",
000056 => x"E59F105C",
000057 => x"E59F205C",
000058 => x"E59F305C",
000059 => x"E1520003",
000060 => x"0A000002",
000061 => x"34910004",
000062 => x"34820004",
000063 => x"3AFFFFFA",
000064 => x"E3A00000",
000065 => x"E59F1044",
000066 => x"E59F2044",
000067 => x"E1510002",
000068 => x"0A000001",
000069 => x"34810004",
000070 => x"3AFFFFFB",
000071 => x"E3A00000",
000072 => x"E1A01000",
000073 => x"E1A02000",
000074 => x"E1A0B000",
000075 => x"E1A07000",
000076 => x"E59FA020",
000077 => x"E1A0E00F",
000078 => x"E1A0F00A",
000079 => x"EAFFFFFE",
000080 => x"00002000",
000081 => x"FFF0054C",
000082 => x"00000000",
000083 => x"FFF0054C",
000084 => x"00000000",
000085 => x"FFF0054C",
000086 => x"FFF002E4",
000087 => x"E3E02A0F",
000088 => x"E5123FE3",
000089 => x"E3130002",
000090 => x"E3E00000",
000091 => x"15120FE7",
000092 => x"E1A0F00E",
000093 => x"E20000FF",
000094 => x"E3E02A0F",
000095 => x"E5123FE3",
000096 => x"E3130001",
000097 => x"0AFFFFFC",
000098 => x"E5020FE7",
000099 => x"E1A0F00E",
000100 => x"E92D4010",
000101 => x"E1A04000",
000102 => x"E5D00000",
000103 => x"E3500000",
000104 => x"1A000003",
000105 => x"EA000005",
000106 => x"E5F40001",
000107 => x"E3500000",
000108 => x"0A000002",
000109 => x"EBFFFFEE",
000110 => x"E3500000",
000111 => x"AAFFFFF9",
000112 => x"E1A00004",
000113 => x"E8BD8010",
000114 => x"E92D4030",
000115 => x"E3A05000",
000116 => x"E4954004",
000117 => x"E1A00C24",
000118 => x"EBFFFFE5",
000119 => x"E1A00824",
000120 => x"E20000FF",
000121 => x"EBFFFFE2",
000122 => x"E1A00424",
000123 => x"E20000FF",
000124 => x"E20440FF",
000125 => x"EBFFFFDE",
000126 => x"E1A00004",
000127 => x"EBFFFFDC",
000128 => x"E3A03502",
000129 => x"E2833A02",
000130 => x"E1550003",
000131 => x"1AFFFFEF",
000132 => x"E1A00000",
000133 => x"E1A00000",
000134 => x"EAFFFFFC",
000135 => x"E3E02A0F",
000136 => x"E3A03000",
000137 => x"E5023FF3",
000138 => x"E52DE004",
000139 => x"E5023FEB",
000140 => x"E59F001C",
000141 => x"EBFFFFD5",
000142 => x"EE163F16",
000143 => x"E3C33008",
000144 => x"EE063F16",
000145 => x"E3A0F000",
000146 => x"E1A00000",
000147 => x"E1A00000",
000148 => x"EAFFFFFC",
000149 => x"FFF0044C",
000150 => x"E92D40F0",
000151 => x"E59F0078",
000152 => x"EBFFFFCA",
000153 => x"E59F2074",
000154 => x"E3A01000",
000155 => x"E3E03A0F",
000156 => x"E3A04626",
000157 => x"E5032FF3",
000158 => x"E2844B96",
000159 => x"E5031FEB",
000160 => x"E1A06001",
000161 => x"E2844C02",
000162 => x"E3A05020",
000163 => x"E1A07001",
000164 => x"EBFFFFB1",
000165 => x"E3700001",
000166 => x"0A00000B",
000167 => x"E2455008",
000168 => x"E1866510",
000169 => x"E3550000",
000170 => x"04876004",
000171 => x"02855020",
000172 => x"03A06000",
000173 => x"EBFFFFA8",
000174 => x"E3A04626",
000175 => x"E2844B96",
000176 => x"E3700001",
000177 => x"E2844C02",
000178 => x"1AFFFFF3",
000179 => x"E2544001",
000180 => x"1AFFFFEE",
000181 => x"E8BD40F0",
000182 => x"EAFFFFCF",
000183 => x"FFF00468",
000184 => x"07173BDE",
000185 => x"E59F313C",
000186 => x"E3E01A0F",
000187 => x"E3A02000",
000188 => x"E5013FF3",
000189 => x"E92D4030",
000190 => x"E5012FEB",
000191 => x"EE163F16",
000192 => x"E3833008",
000193 => x"EE063F16",
000194 => x"E3A00641",
000195 => x"E3A0140B",
000196 => x"E3E03A01",
000197 => x"E2811C06",
000198 => x"E28220FF",
000199 => x"E280090E",
000200 => x"E3A0CE41",
000201 => x"E50310FF",
000202 => x"E2800023",
000203 => x"E50320F7",
000204 => x"E28CC001",
000205 => x"E3A02502",
000206 => x"E59F10EC",
000207 => x"E50300EB",
000208 => x"E2822A02",
000209 => x"E503C0EF",
000210 => x"E3A03A02",
000211 => x"E4831004",
000212 => x"E1530002",
000213 => x"1AFFFFFC",
000214 => x"E59F00D0",
000215 => x"EBFFFF8B",
000216 => x"E59F00CC",
000217 => x"EBFFFF89",
000218 => x"E59F00C8",
000219 => x"EBFFFF87",
000220 => x"E59F00C4",
000221 => x"EBFFFF85",
000222 => x"E59F00C0",
000223 => x"EBFFFF83",
000224 => x"E59F00BC",
000225 => x"EBFFFF81",
000226 => x"E59F00B8",
000227 => x"EBFFFF7F",
000228 => x"E3A04626",
000229 => x"E2844B96",
000230 => x"E2844C02",
000231 => x"E3E05A0F",
000232 => x"EA00000B",
000233 => x"E3500078",
000234 => x"0A000019",
000235 => x"E5153FFB",
000236 => x"E3130801",
000237 => x"0A000016",
000238 => x"E3500030",
000239 => x"12444001",
000240 => x"0A000010",
000241 => x"E1A03944",
000242 => x"E3540000",
000243 => x"E5053FEF",
000244 => x"0A000009",
000245 => x"EBFFFF60",
000246 => x"E3500031",
000247 => x"E1A02000",
000248 => x"1AFFFFEF",
000249 => x"EBFFFF62",
000250 => x"EBFFFF9A",
000251 => x"E1A03944",
000252 => x"E3540000",
000253 => x"E5053FEF",
000254 => x"1AFFFFF5",
000255 => x"EBFFFF86",
000256 => x"E3A00000",
000257 => x"E8BD8030",
000258 => x"EBFFFF59",
000259 => x"EBFFFF6D",
000260 => x"EAFFFFEB",
000261 => x"E20200FF",
000262 => x"EBFFFF55",
000263 => x"EBFFFF7E",
000264 => x"E3A00000",
000265 => x"E8BD8030",
000266 => x"0F972E78",
000267 => x"CAFEBABE",
000268 => x"FFF00480",
000269 => x"FFF004B8",
000270 => x"FFF004E8",
000271 => x"FFF00500",
000272 => x"FFF00510",
000273 => x"FFF00524",
000274 => x"FFF00540",
000275 => x"0D0A5374",
000276 => x"61727469",
000277 => x"6E672061",
000278 => x"70706C69",
000279 => x"63617469",
000280 => x"6F6E2E2E",
000281 => x"2E0D0A00",
000282 => x"0D0A5761",
000283 => x"6974696E",
000284 => x"6720666F",
000285 => x"72206461",
000286 => x"74610D0A",
000287 => x"00000000",
000288 => x"0D0A5354",
000289 => x"4F524D20",
000290 => x"436F7265",
000291 => x"2050726F",
000292 => x"63657373",
000293 => x"6F722053",
000294 => x"79737465",
000295 => x"6D202D20",
000296 => x"62792053",
000297 => x"74657068",
000298 => x"616E204E",
000299 => x"6F6C7469",
000300 => x"6E670D0A",
000301 => x"00000000",
000302 => x"426F6F74",
000303 => x"6C6F6164",
000304 => x"65722066",
000305 => x"6F722053",
000306 => x"544F524D",
000307 => x"20536F43",
000308 => x"206F6E20",
000309 => x"416C7465",
000310 => x"72612044",
000311 => x"45322D42",
000312 => x"6F617264",
000313 => x"0D0A0000",
000314 => x"56657273",
000315 => x"696F6E3A",
000316 => x"2031322E",
000317 => x"30332E32",
000318 => x"3031320D",
000319 => x"0A000000",
000320 => x"0D0A303A",
000321 => x"2052414D",
000322 => x"2064756D",
000323 => x"700D0A00",
000324 => x"313A204C",
000325 => x"6F616420",
000326 => x"76696120",
000327 => x"55415254",
000328 => x"0D0A0000",
000329 => x"783A204A",
000330 => x"756D7020",
000331 => x"746F2061",
000332 => x"70706C69",
000333 => x"63617469",
000334 => x"6F6E0D0A",
000335 => x"00000000",
000336 => x"0D0A5365",
000337 => x"6C656374",
000338 => x"3A200000",
others => x"F0013007"

	);

	--- Altera DE0nano-Board Bootloader Image -------------------------
	constant DE0N_BOOTLOADER_IMAGE : BOOT_ROM_TYPE :=
	(
		others => x"F0013007"
	);

	--- Init Memory Function ---
	function load_image(IMAGE_ID : string) return BOOT_ROM_TYPE is
		variable TEMP_MEM : BOOT_ROM_TYPE;
	begin
		if (IMAGE_ID = "DE2_BL_IMG") then
			TEMP_MEM := DE2_BOOTLOADER_IMAGE;
		elsif (IMAGE_ID = "DE0N_BL_IMG") then
			TEMP_MEM := DE0N_BOOTLOADER_IMAGE;
		else
			TEMP_MEM := (others => x"F0013007");
		end if;
		return TEMP_MEM;
	end load_image;

	--- ROM Signal ---
	signal BOOT_ROM : BOOT_ROM_TYPE := load_image(INIT_IMAGE_ID);

begin

	-- ROM WB Access ---------------------------------------------------------------------------------------
	-- --------------------------------------------------------------------------------------------------------
		ROM_ACCESS: process(WB_CLK_I)
		begin
			--- Sync Write ---
			if rising_edge(WB_CLK_I) then

				--- Data Read ---
				if (WB_STB_I = '1') then
					WB_DATA_INT <= BOOT_ROM(to_integer(unsigned(WB_ADR_I)));
				end if;

				--- ACK Control ---
				if (WB_RST_I = '1') then
					WB_ACK_O_INT <= '0';
				elsif (WB_CTI_I = "000") or (WB_CTI_I = "111") then
					WB_ACK_O_INT <= WB_STB_I and (not WB_ACK_O_INT);
				else
					WB_ACK_O_INT <= WB_STB_I; -- data is valid one cycle later
				end if;
			end if;
		end process ROM_ACCESS;

		--- Output Gate ---
		WB_DATA_O <= WB_DATA_INT when (OUTPUT_GATE = FALSE) or ((OUTPUT_GATE = TRUE) and (WB_STB_I = '1')) else x"00000000";

		--- ACK Signal ---
		WB_ACK_O  <= WB_ACK_O_INT;

		--- Throttle ---
		WB_HALT_O <= '0'; -- yeay, we're at full speed!

		--- Error ---
		WB_ERR_O  <= '0'; -- nothing can go wrong ;)



end Behavioral;