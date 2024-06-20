-- Created by IP Generator (Version 2023.2-SP1 build 147282)
-- Instantiation Template
--
-- Insert the following codes into your VHDL file.
--   * Change the_instance_name to your own instance name.
--   * Change the net names in the port map.


COMPONENT Debug_pll
  PORT (
    clkout0 : OUT STD_LOGIC;
    lock : OUT STD_LOGIC;
    clkin1_p : IN STD_LOGIC;
    clkin1_n : IN STD_LOGIC
  );
END COMPONENT;


the_instance_name : Debug_pll
  PORT MAP (
    clkout0 => clkout0,
    lock => lock,
    clkin1_p => clkin1_p,
    clkin1_n => clkin1_n
  );
