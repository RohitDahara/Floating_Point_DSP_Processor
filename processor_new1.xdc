# Clock Input
set_property -dict {PACKAGE_PIN F14 IOSTANDARD LVCMOS33} [get_ports clk]
create_clock -period 10.000 -name clk [get_ports clk]

# Anode control lines for both displays (0 to 7)
set_property -dict {PACKAGE_PIN D5 IOSTANDARD LVCMOS33} [get_ports {anode[0]}]  
set_property -dict {PACKAGE_PIN C4 IOSTANDARD LVCMOS33} [get_ports {anode[1]}]  
set_property -dict {PACKAGE_PIN C7 IOSTANDARD LVCMOS33} [get_ports {anode[2]}]  
set_property -dict {PACKAGE_PIN A8 IOSTANDARD LVCMOS33} [get_ports {anode[3]}]  

set_property -dict {PACKAGE_PIN H3 IOSTANDARD LVCMOS33} [get_ports {anode[4]}]  
set_property -dict {PACKAGE_PIN J4 IOSTANDARD LVCMOS33} [get_ports {anode[5]}]  
set_property -dict {PACKAGE_PIN F3 IOSTANDARD LVCMOS33} [get_ports {anode[6]}]  
set_property -dict {PACKAGE_PIN E4 IOSTANDARD LVCMOS33} [get_ports {anode[7]}]  

# Segment connections for Display 0 ("4188")
set_property -dict {PACKAGE_PIN D7 IOSTANDARD LVCMOS33} [get_ports {seg0[0]}]
set_property -dict {PACKAGE_PIN C5 IOSTANDARD LVCMOS33} [get_ports {seg0[1]}]
set_property -dict {PACKAGE_PIN A5 IOSTANDARD LVCMOS33} [get_ports {seg0[2]}]
set_property -dict {PACKAGE_PIN B7 IOSTANDARD LVCMOS33} [get_ports {seg0[3]}]
set_property -dict {PACKAGE_PIN A7 IOSTANDARD LVCMOS33} [get_ports {seg0[4]}]
set_property -dict {PACKAGE_PIN D6 IOSTANDARD LVCMOS33} [get_ports {seg0[5]}]
set_property -dict {PACKAGE_PIN B5 IOSTANDARD LVCMOS33} [get_ports {seg0[6]}]

# Segment connections for Display 1 ("BC6A")
set_property -dict {PACKAGE_PIN F4 IOSTANDARD LVCMOS33} [get_ports {seg1[0]}]
set_property -dict {PACKAGE_PIN J3 IOSTANDARD LVCMOS33} [get_ports {seg1[1]}]
set_property -dict {PACKAGE_PIN D2 IOSTANDARD LVCMOS33} [get_ports {seg1[2]}]
set_property -dict {PACKAGE_PIN C2 IOSTANDARD LVCMOS33} [get_ports {seg1[3]}]
set_property -dict {PACKAGE_PIN B1 IOSTANDARD LVCMOS33} [get_ports {seg1[4]}]
set_property -dict {PACKAGE_PIN H4 IOSTANDARD LVCMOS33} [get_ports {seg1[5]}]
set_property -dict {PACKAGE_PIN D1 IOSTANDARD LVCMOS33} [get_ports {seg1[6]}]

# Drive strength for all outputs
set_property DRIVE 8 [get_ports {seg0[*]}]
set_property DRIVE 8 [get_ports {seg1[*]}]
set_property DRIVE 8 [get_ports {anode[*]}]

# Reset Input Pin Configuration
set_property -dict {PACKAGE_PIN J2 IOSTANDARD LVCMOS33} [get_ports {reset}]
