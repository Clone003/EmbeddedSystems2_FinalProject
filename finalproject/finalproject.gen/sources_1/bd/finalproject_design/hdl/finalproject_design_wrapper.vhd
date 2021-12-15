--Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
----------------------------------------------------------------------------------
--Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
--Date        : Tue Dec 14 16:58:30 2021
--Host        : ece31 running 64-bit Ubuntu 20.04.2 LTS
--Command     : generate_target finalproject_design_wrapper.bd
--Design      : finalproject_design_wrapper
--Purpose     : IP block netlist
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
library UNISIM;
use UNISIM.VCOMPONENTS.ALL;
entity finalproject_design_wrapper is
  port (
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_cas_n : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    bt2_pin10_io : inout STD_LOGIC;
    bt2_pin1_io : inout STD_LOGIC;
    bt2_pin2_io : inout STD_LOGIC;
    bt2_pin3_io : inout STD_LOGIC;
    bt2_pin4_io : inout STD_LOGIC;
    bt2_pin7_io : inout STD_LOGIC;
    bt2_pin8_io : inout STD_LOGIC;
    bt2_pin9_io : inout STD_LOGIC;
    gps_pin10_io : inout STD_LOGIC;
    gps_pin1_io : inout STD_LOGIC;
    gps_pin2_io : inout STD_LOGIC;
    gps_pin3_io : inout STD_LOGIC;
    gps_pin4_io : inout STD_LOGIC;
    gps_pin7_io : inout STD_LOGIC;
    gps_pin8_io : inout STD_LOGIC;
    gps_pin9_io : inout STD_LOGIC;
    hygro_pin10_io : inout STD_LOGIC;
    hygro_pin1_io : inout STD_LOGIC;
    hygro_pin2_io : inout STD_LOGIC;
    hygro_pin3_io : inout STD_LOGIC;
    hygro_pin4_io : inout STD_LOGIC;
    hygro_pin7_io : inout STD_LOGIC;
    hygro_pin8_io : inout STD_LOGIC;
    hygro_pin9_io : inout STD_LOGIC;
    oled_pin10_io : inout STD_LOGIC;
    oled_pin1_io : inout STD_LOGIC;
    oled_pin2_io : inout STD_LOGIC;
    oled_pin3_io : inout STD_LOGIC;
    oled_pin4_io : inout STD_LOGIC;
    oled_pin7_io : inout STD_LOGIC;
    oled_pin8_io : inout STD_LOGIC;
    oled_pin9_io : inout STD_LOGIC
  );
end finalproject_design_wrapper;

architecture STRUCTURE of finalproject_design_wrapper is
  component finalproject_design is
  port (
    bt2_pin1_o : out STD_LOGIC;
    bt2_pin7_i : in STD_LOGIC;
    bt2_pin2_o : out STD_LOGIC;
    bt2_pin8_i : in STD_LOGIC;
    bt2_pin3_o : out STD_LOGIC;
    bt2_pin9_i : in STD_LOGIC;
    bt2_pin10_o : out STD_LOGIC;
    bt2_pin4_o : out STD_LOGIC;
    bt2_pin3_i : in STD_LOGIC;
    bt2_pin4_i : in STD_LOGIC;
    bt2_pin1_i : in STD_LOGIC;
    bt2_pin2_i : in STD_LOGIC;
    bt2_pin10_t : out STD_LOGIC;
    bt2_pin8_t : out STD_LOGIC;
    bt2_pin9_t : out STD_LOGIC;
    bt2_pin4_t : out STD_LOGIC;
    bt2_pin9_o : out STD_LOGIC;
    bt2_pin10_i : in STD_LOGIC;
    bt2_pin7_t : out STD_LOGIC;
    bt2_pin1_t : out STD_LOGIC;
    bt2_pin2_t : out STD_LOGIC;
    bt2_pin7_o : out STD_LOGIC;
    bt2_pin3_t : out STD_LOGIC;
    bt2_pin8_o : out STD_LOGIC;
    oled_pin1_o : out STD_LOGIC;
    oled_pin7_i : in STD_LOGIC;
    oled_pin2_o : out STD_LOGIC;
    oled_pin8_i : in STD_LOGIC;
    oled_pin3_o : out STD_LOGIC;
    oled_pin9_i : in STD_LOGIC;
    oled_pin10_o : out STD_LOGIC;
    oled_pin4_o : out STD_LOGIC;
    oled_pin3_i : in STD_LOGIC;
    oled_pin4_i : in STD_LOGIC;
    oled_pin1_i : in STD_LOGIC;
    oled_pin2_i : in STD_LOGIC;
    oled_pin10_t : out STD_LOGIC;
    oled_pin8_t : out STD_LOGIC;
    oled_pin9_t : out STD_LOGIC;
    oled_pin4_t : out STD_LOGIC;
    oled_pin9_o : out STD_LOGIC;
    oled_pin10_i : in STD_LOGIC;
    oled_pin7_t : out STD_LOGIC;
    oled_pin1_t : out STD_LOGIC;
    oled_pin2_t : out STD_LOGIC;
    oled_pin7_o : out STD_LOGIC;
    oled_pin3_t : out STD_LOGIC;
    oled_pin8_o : out STD_LOGIC;
    DDR_cas_n : inout STD_LOGIC;
    DDR_cke : inout STD_LOGIC;
    DDR_ck_n : inout STD_LOGIC;
    DDR_ck_p : inout STD_LOGIC;
    DDR_cs_n : inout STD_LOGIC;
    DDR_reset_n : inout STD_LOGIC;
    DDR_odt : inout STD_LOGIC;
    DDR_ras_n : inout STD_LOGIC;
    DDR_we_n : inout STD_LOGIC;
    DDR_ba : inout STD_LOGIC_VECTOR ( 2 downto 0 );
    DDR_addr : inout STD_LOGIC_VECTOR ( 14 downto 0 );
    DDR_dm : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dq : inout STD_LOGIC_VECTOR ( 31 downto 0 );
    DDR_dqs_n : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    DDR_dqs_p : inout STD_LOGIC_VECTOR ( 3 downto 0 );
    FIXED_IO_mio : inout STD_LOGIC_VECTOR ( 53 downto 0 );
    FIXED_IO_ddr_vrn : inout STD_LOGIC;
    FIXED_IO_ddr_vrp : inout STD_LOGIC;
    FIXED_IO_ps_srstb : inout STD_LOGIC;
    FIXED_IO_ps_clk : inout STD_LOGIC;
    FIXED_IO_ps_porb : inout STD_LOGIC;
    hygro_pin1_o : out STD_LOGIC;
    hygro_pin7_i : in STD_LOGIC;
    hygro_pin2_o : out STD_LOGIC;
    hygro_pin8_i : in STD_LOGIC;
    hygro_pin3_o : out STD_LOGIC;
    hygro_pin9_i : in STD_LOGIC;
    hygro_pin10_o : out STD_LOGIC;
    hygro_pin4_o : out STD_LOGIC;
    hygro_pin3_i : in STD_LOGIC;
    hygro_pin4_i : in STD_LOGIC;
    hygro_pin1_i : in STD_LOGIC;
    hygro_pin2_i : in STD_LOGIC;
    hygro_pin10_t : out STD_LOGIC;
    hygro_pin8_t : out STD_LOGIC;
    hygro_pin9_t : out STD_LOGIC;
    hygro_pin4_t : out STD_LOGIC;
    hygro_pin9_o : out STD_LOGIC;
    hygro_pin10_i : in STD_LOGIC;
    hygro_pin7_t : out STD_LOGIC;
    hygro_pin1_t : out STD_LOGIC;
    hygro_pin2_t : out STD_LOGIC;
    hygro_pin7_o : out STD_LOGIC;
    hygro_pin3_t : out STD_LOGIC;
    hygro_pin8_o : out STD_LOGIC;
    gps_pin1_o : out STD_LOGIC;
    gps_pin7_i : in STD_LOGIC;
    gps_pin2_o : out STD_LOGIC;
    gps_pin8_i : in STD_LOGIC;
    gps_pin3_o : out STD_LOGIC;
    gps_pin9_i : in STD_LOGIC;
    gps_pin10_o : out STD_LOGIC;
    gps_pin4_o : out STD_LOGIC;
    gps_pin3_i : in STD_LOGIC;
    gps_pin4_i : in STD_LOGIC;
    gps_pin1_i : in STD_LOGIC;
    gps_pin2_i : in STD_LOGIC;
    gps_pin10_t : out STD_LOGIC;
    gps_pin8_t : out STD_LOGIC;
    gps_pin9_t : out STD_LOGIC;
    gps_pin4_t : out STD_LOGIC;
    gps_pin9_o : out STD_LOGIC;
    gps_pin10_i : in STD_LOGIC;
    gps_pin7_t : out STD_LOGIC;
    gps_pin1_t : out STD_LOGIC;
    gps_pin2_t : out STD_LOGIC;
    gps_pin7_o : out STD_LOGIC;
    gps_pin3_t : out STD_LOGIC;
    gps_pin8_o : out STD_LOGIC
  );
  end component finalproject_design;
  component IOBUF is
  port (
    I : in STD_LOGIC;
    O : out STD_LOGIC;
    T : in STD_LOGIC;
    IO : inout STD_LOGIC
  );
  end component IOBUF;
  signal bt2_pin10_i : STD_LOGIC;
  signal bt2_pin10_o : STD_LOGIC;
  signal bt2_pin10_t : STD_LOGIC;
  signal bt2_pin1_i : STD_LOGIC;
  signal bt2_pin1_o : STD_LOGIC;
  signal bt2_pin1_t : STD_LOGIC;
  signal bt2_pin2_i : STD_LOGIC;
  signal bt2_pin2_o : STD_LOGIC;
  signal bt2_pin2_t : STD_LOGIC;
  signal bt2_pin3_i : STD_LOGIC;
  signal bt2_pin3_o : STD_LOGIC;
  signal bt2_pin3_t : STD_LOGIC;
  signal bt2_pin4_i : STD_LOGIC;
  signal bt2_pin4_o : STD_LOGIC;
  signal bt2_pin4_t : STD_LOGIC;
  signal bt2_pin7_i : STD_LOGIC;
  signal bt2_pin7_o : STD_LOGIC;
  signal bt2_pin7_t : STD_LOGIC;
  signal bt2_pin8_i : STD_LOGIC;
  signal bt2_pin8_o : STD_LOGIC;
  signal bt2_pin8_t : STD_LOGIC;
  signal bt2_pin9_i : STD_LOGIC;
  signal bt2_pin9_o : STD_LOGIC;
  signal bt2_pin9_t : STD_LOGIC;
  signal gps_pin10_i : STD_LOGIC;
  signal gps_pin10_o : STD_LOGIC;
  signal gps_pin10_t : STD_LOGIC;
  signal gps_pin1_i : STD_LOGIC;
  signal gps_pin1_o : STD_LOGIC;
  signal gps_pin1_t : STD_LOGIC;
  signal gps_pin2_i : STD_LOGIC;
  signal gps_pin2_o : STD_LOGIC;
  signal gps_pin2_t : STD_LOGIC;
  signal gps_pin3_i : STD_LOGIC;
  signal gps_pin3_o : STD_LOGIC;
  signal gps_pin3_t : STD_LOGIC;
  signal gps_pin4_i : STD_LOGIC;
  signal gps_pin4_o : STD_LOGIC;
  signal gps_pin4_t : STD_LOGIC;
  signal gps_pin7_i : STD_LOGIC;
  signal gps_pin7_o : STD_LOGIC;
  signal gps_pin7_t : STD_LOGIC;
  signal gps_pin8_i : STD_LOGIC;
  signal gps_pin8_o : STD_LOGIC;
  signal gps_pin8_t : STD_LOGIC;
  signal gps_pin9_i : STD_LOGIC;
  signal gps_pin9_o : STD_LOGIC;
  signal gps_pin9_t : STD_LOGIC;
  signal hygro_pin10_i : STD_LOGIC;
  signal hygro_pin10_o : STD_LOGIC;
  signal hygro_pin10_t : STD_LOGIC;
  signal hygro_pin1_i : STD_LOGIC;
  signal hygro_pin1_o : STD_LOGIC;
  signal hygro_pin1_t : STD_LOGIC;
  signal hygro_pin2_i : STD_LOGIC;
  signal hygro_pin2_o : STD_LOGIC;
  signal hygro_pin2_t : STD_LOGIC;
  signal hygro_pin3_i : STD_LOGIC;
  signal hygro_pin3_o : STD_LOGIC;
  signal hygro_pin3_t : STD_LOGIC;
  signal hygro_pin4_i : STD_LOGIC;
  signal hygro_pin4_o : STD_LOGIC;
  signal hygro_pin4_t : STD_LOGIC;
  signal hygro_pin7_i : STD_LOGIC;
  signal hygro_pin7_o : STD_LOGIC;
  signal hygro_pin7_t : STD_LOGIC;
  signal hygro_pin8_i : STD_LOGIC;
  signal hygro_pin8_o : STD_LOGIC;
  signal hygro_pin8_t : STD_LOGIC;
  signal hygro_pin9_i : STD_LOGIC;
  signal hygro_pin9_o : STD_LOGIC;
  signal hygro_pin9_t : STD_LOGIC;
  signal oled_pin10_i : STD_LOGIC;
  signal oled_pin10_o : STD_LOGIC;
  signal oled_pin10_t : STD_LOGIC;
  signal oled_pin1_i : STD_LOGIC;
  signal oled_pin1_o : STD_LOGIC;
  signal oled_pin1_t : STD_LOGIC;
  signal oled_pin2_i : STD_LOGIC;
  signal oled_pin2_o : STD_LOGIC;
  signal oled_pin2_t : STD_LOGIC;
  signal oled_pin3_i : STD_LOGIC;
  signal oled_pin3_o : STD_LOGIC;
  signal oled_pin3_t : STD_LOGIC;
  signal oled_pin4_i : STD_LOGIC;
  signal oled_pin4_o : STD_LOGIC;
  signal oled_pin4_t : STD_LOGIC;
  signal oled_pin7_i : STD_LOGIC;
  signal oled_pin7_o : STD_LOGIC;
  signal oled_pin7_t : STD_LOGIC;
  signal oled_pin8_i : STD_LOGIC;
  signal oled_pin8_o : STD_LOGIC;
  signal oled_pin8_t : STD_LOGIC;
  signal oled_pin9_i : STD_LOGIC;
  signal oled_pin9_o : STD_LOGIC;
  signal oled_pin9_t : STD_LOGIC;
begin
bt2_pin10_iobuf: component IOBUF
     port map (
      I => bt2_pin10_o,
      IO => bt2_pin10_io,
      O => bt2_pin10_i,
      T => bt2_pin10_t
    );
bt2_pin1_iobuf: component IOBUF
     port map (
      I => bt2_pin1_o,
      IO => bt2_pin1_io,
      O => bt2_pin1_i,
      T => bt2_pin1_t
    );
bt2_pin2_iobuf: component IOBUF
     port map (
      I => bt2_pin2_o,
      IO => bt2_pin2_io,
      O => bt2_pin2_i,
      T => bt2_pin2_t
    );
bt2_pin3_iobuf: component IOBUF
     port map (
      I => bt2_pin3_o,
      IO => bt2_pin3_io,
      O => bt2_pin3_i,
      T => bt2_pin3_t
    );
bt2_pin4_iobuf: component IOBUF
     port map (
      I => bt2_pin4_o,
      IO => bt2_pin4_io,
      O => bt2_pin4_i,
      T => bt2_pin4_t
    );
bt2_pin7_iobuf: component IOBUF
     port map (
      I => bt2_pin7_o,
      IO => bt2_pin7_io,
      O => bt2_pin7_i,
      T => bt2_pin7_t
    );
bt2_pin8_iobuf: component IOBUF
     port map (
      I => bt2_pin8_o,
      IO => bt2_pin8_io,
      O => bt2_pin8_i,
      T => bt2_pin8_t
    );
bt2_pin9_iobuf: component IOBUF
     port map (
      I => bt2_pin9_o,
      IO => bt2_pin9_io,
      O => bt2_pin9_i,
      T => bt2_pin9_t
    );
finalproject_design_i: component finalproject_design
     port map (
      DDR_addr(14 downto 0) => DDR_addr(14 downto 0),
      DDR_ba(2 downto 0) => DDR_ba(2 downto 0),
      DDR_cas_n => DDR_cas_n,
      DDR_ck_n => DDR_ck_n,
      DDR_ck_p => DDR_ck_p,
      DDR_cke => DDR_cke,
      DDR_cs_n => DDR_cs_n,
      DDR_dm(3 downto 0) => DDR_dm(3 downto 0),
      DDR_dq(31 downto 0) => DDR_dq(31 downto 0),
      DDR_dqs_n(3 downto 0) => DDR_dqs_n(3 downto 0),
      DDR_dqs_p(3 downto 0) => DDR_dqs_p(3 downto 0),
      DDR_odt => DDR_odt,
      DDR_ras_n => DDR_ras_n,
      DDR_reset_n => DDR_reset_n,
      DDR_we_n => DDR_we_n,
      FIXED_IO_ddr_vrn => FIXED_IO_ddr_vrn,
      FIXED_IO_ddr_vrp => FIXED_IO_ddr_vrp,
      FIXED_IO_mio(53 downto 0) => FIXED_IO_mio(53 downto 0),
      FIXED_IO_ps_clk => FIXED_IO_ps_clk,
      FIXED_IO_ps_porb => FIXED_IO_ps_porb,
      FIXED_IO_ps_srstb => FIXED_IO_ps_srstb,
      bt2_pin10_i => bt2_pin10_i,
      bt2_pin10_o => bt2_pin10_o,
      bt2_pin10_t => bt2_pin10_t,
      bt2_pin1_i => bt2_pin1_i,
      bt2_pin1_o => bt2_pin1_o,
      bt2_pin1_t => bt2_pin1_t,
      bt2_pin2_i => bt2_pin2_i,
      bt2_pin2_o => bt2_pin2_o,
      bt2_pin2_t => bt2_pin2_t,
      bt2_pin3_i => bt2_pin3_i,
      bt2_pin3_o => bt2_pin3_o,
      bt2_pin3_t => bt2_pin3_t,
      bt2_pin4_i => bt2_pin4_i,
      bt2_pin4_o => bt2_pin4_o,
      bt2_pin4_t => bt2_pin4_t,
      bt2_pin7_i => bt2_pin7_i,
      bt2_pin7_o => bt2_pin7_o,
      bt2_pin7_t => bt2_pin7_t,
      bt2_pin8_i => bt2_pin8_i,
      bt2_pin8_o => bt2_pin8_o,
      bt2_pin8_t => bt2_pin8_t,
      bt2_pin9_i => bt2_pin9_i,
      bt2_pin9_o => bt2_pin9_o,
      bt2_pin9_t => bt2_pin9_t,
      gps_pin10_i => gps_pin10_i,
      gps_pin10_o => gps_pin10_o,
      gps_pin10_t => gps_pin10_t,
      gps_pin1_i => gps_pin1_i,
      gps_pin1_o => gps_pin1_o,
      gps_pin1_t => gps_pin1_t,
      gps_pin2_i => gps_pin2_i,
      gps_pin2_o => gps_pin2_o,
      gps_pin2_t => gps_pin2_t,
      gps_pin3_i => gps_pin3_i,
      gps_pin3_o => gps_pin3_o,
      gps_pin3_t => gps_pin3_t,
      gps_pin4_i => gps_pin4_i,
      gps_pin4_o => gps_pin4_o,
      gps_pin4_t => gps_pin4_t,
      gps_pin7_i => gps_pin7_i,
      gps_pin7_o => gps_pin7_o,
      gps_pin7_t => gps_pin7_t,
      gps_pin8_i => gps_pin8_i,
      gps_pin8_o => gps_pin8_o,
      gps_pin8_t => gps_pin8_t,
      gps_pin9_i => gps_pin9_i,
      gps_pin9_o => gps_pin9_o,
      gps_pin9_t => gps_pin9_t,
      hygro_pin10_i => hygro_pin10_i,
      hygro_pin10_o => hygro_pin10_o,
      hygro_pin10_t => hygro_pin10_t,
      hygro_pin1_i => hygro_pin1_i,
      hygro_pin1_o => hygro_pin1_o,
      hygro_pin1_t => hygro_pin1_t,
      hygro_pin2_i => hygro_pin2_i,
      hygro_pin2_o => hygro_pin2_o,
      hygro_pin2_t => hygro_pin2_t,
      hygro_pin3_i => hygro_pin3_i,
      hygro_pin3_o => hygro_pin3_o,
      hygro_pin3_t => hygro_pin3_t,
      hygro_pin4_i => hygro_pin4_i,
      hygro_pin4_o => hygro_pin4_o,
      hygro_pin4_t => hygro_pin4_t,
      hygro_pin7_i => hygro_pin7_i,
      hygro_pin7_o => hygro_pin7_o,
      hygro_pin7_t => hygro_pin7_t,
      hygro_pin8_i => hygro_pin8_i,
      hygro_pin8_o => hygro_pin8_o,
      hygro_pin8_t => hygro_pin8_t,
      hygro_pin9_i => hygro_pin9_i,
      hygro_pin9_o => hygro_pin9_o,
      hygro_pin9_t => hygro_pin9_t,
      oled_pin10_i => oled_pin10_i,
      oled_pin10_o => oled_pin10_o,
      oled_pin10_t => oled_pin10_t,
      oled_pin1_i => oled_pin1_i,
      oled_pin1_o => oled_pin1_o,
      oled_pin1_t => oled_pin1_t,
      oled_pin2_i => oled_pin2_i,
      oled_pin2_o => oled_pin2_o,
      oled_pin2_t => oled_pin2_t,
      oled_pin3_i => oled_pin3_i,
      oled_pin3_o => oled_pin3_o,
      oled_pin3_t => oled_pin3_t,
      oled_pin4_i => oled_pin4_i,
      oled_pin4_o => oled_pin4_o,
      oled_pin4_t => oled_pin4_t,
      oled_pin7_i => oled_pin7_i,
      oled_pin7_o => oled_pin7_o,
      oled_pin7_t => oled_pin7_t,
      oled_pin8_i => oled_pin8_i,
      oled_pin8_o => oled_pin8_o,
      oled_pin8_t => oled_pin8_t,
      oled_pin9_i => oled_pin9_i,
      oled_pin9_o => oled_pin9_o,
      oled_pin9_t => oled_pin9_t
    );
gps_pin10_iobuf: component IOBUF
     port map (
      I => gps_pin10_o,
      IO => gps_pin10_io,
      O => gps_pin10_i,
      T => gps_pin10_t
    );
gps_pin1_iobuf: component IOBUF
     port map (
      I => gps_pin1_o,
      IO => gps_pin1_io,
      O => gps_pin1_i,
      T => gps_pin1_t
    );
gps_pin2_iobuf: component IOBUF
     port map (
      I => gps_pin2_o,
      IO => gps_pin2_io,
      O => gps_pin2_i,
      T => gps_pin2_t
    );
gps_pin3_iobuf: component IOBUF
     port map (
      I => gps_pin3_o,
      IO => gps_pin3_io,
      O => gps_pin3_i,
      T => gps_pin3_t
    );
gps_pin4_iobuf: component IOBUF
     port map (
      I => gps_pin4_o,
      IO => gps_pin4_io,
      O => gps_pin4_i,
      T => gps_pin4_t
    );
gps_pin7_iobuf: component IOBUF
     port map (
      I => gps_pin7_o,
      IO => gps_pin7_io,
      O => gps_pin7_i,
      T => gps_pin7_t
    );
gps_pin8_iobuf: component IOBUF
     port map (
      I => gps_pin8_o,
      IO => gps_pin8_io,
      O => gps_pin8_i,
      T => gps_pin8_t
    );
gps_pin9_iobuf: component IOBUF
     port map (
      I => gps_pin9_o,
      IO => gps_pin9_io,
      O => gps_pin9_i,
      T => gps_pin9_t
    );
hygro_pin10_iobuf: component IOBUF
     port map (
      I => hygro_pin10_o,
      IO => hygro_pin10_io,
      O => hygro_pin10_i,
      T => hygro_pin10_t
    );
hygro_pin1_iobuf: component IOBUF
     port map (
      I => hygro_pin1_o,
      IO => hygro_pin1_io,
      O => hygro_pin1_i,
      T => hygro_pin1_t
    );
hygro_pin2_iobuf: component IOBUF
     port map (
      I => hygro_pin2_o,
      IO => hygro_pin2_io,
      O => hygro_pin2_i,
      T => hygro_pin2_t
    );
hygro_pin3_iobuf: component IOBUF
     port map (
      I => hygro_pin3_o,
      IO => hygro_pin3_io,
      O => hygro_pin3_i,
      T => hygro_pin3_t
    );
hygro_pin4_iobuf: component IOBUF
     port map (
      I => hygro_pin4_o,
      IO => hygro_pin4_io,
      O => hygro_pin4_i,
      T => hygro_pin4_t
    );
hygro_pin7_iobuf: component IOBUF
     port map (
      I => hygro_pin7_o,
      IO => hygro_pin7_io,
      O => hygro_pin7_i,
      T => hygro_pin7_t
    );
hygro_pin8_iobuf: component IOBUF
     port map (
      I => hygro_pin8_o,
      IO => hygro_pin8_io,
      O => hygro_pin8_i,
      T => hygro_pin8_t
    );
hygro_pin9_iobuf: component IOBUF
     port map (
      I => hygro_pin9_o,
      IO => hygro_pin9_io,
      O => hygro_pin9_i,
      T => hygro_pin9_t
    );
oled_pin10_iobuf: component IOBUF
     port map (
      I => oled_pin10_o,
      IO => oled_pin10_io,
      O => oled_pin10_i,
      T => oled_pin10_t
    );
oled_pin1_iobuf: component IOBUF
     port map (
      I => oled_pin1_o,
      IO => oled_pin1_io,
      O => oled_pin1_i,
      T => oled_pin1_t
    );
oled_pin2_iobuf: component IOBUF
     port map (
      I => oled_pin2_o,
      IO => oled_pin2_io,
      O => oled_pin2_i,
      T => oled_pin2_t
    );
oled_pin3_iobuf: component IOBUF
     port map (
      I => oled_pin3_o,
      IO => oled_pin3_io,
      O => oled_pin3_i,
      T => oled_pin3_t
    );
oled_pin4_iobuf: component IOBUF
     port map (
      I => oled_pin4_o,
      IO => oled_pin4_io,
      O => oled_pin4_i,
      T => oled_pin4_t
    );
oled_pin7_iobuf: component IOBUF
     port map (
      I => oled_pin7_o,
      IO => oled_pin7_io,
      O => oled_pin7_i,
      T => oled_pin7_t
    );
oled_pin8_iobuf: component IOBUF
     port map (
      I => oled_pin8_o,
      IO => oled_pin8_io,
      O => oled_pin8_i,
      T => oled_pin8_t
    );
oled_pin9_iobuf: component IOBUF
     port map (
      I => oled_pin9_o,
      IO => oled_pin9_io,
      O => oled_pin9_i,
      T => oled_pin9_t
    );
end STRUCTURE;
