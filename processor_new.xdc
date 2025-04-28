# ================================
# Clock Constraint (100 MHz)
# ================================
create_clock -period 10.000 -name clk -waveform {0.000 5.000} [get_ports clk]

# ================================
# Input Constraints
# ================================
# Assuming external input delay of 2.5 ns (adjust as needed)
set_input_delay -clock clk 2.500 [get_ports clk]
set_input_delay -clock clk 2.500 [get_ports reset]

# ================================
# Output Constraints
# ================================
# Assuming external output delay of 2.5 ns (adjust as needed)
set_output_delay -clock clk 2.500 [get_ports {result[*]}]

# ================================
# Optional: Prevent timing on false paths (if needed)
# ================================
# set_false_path -from [get_ports reset]



