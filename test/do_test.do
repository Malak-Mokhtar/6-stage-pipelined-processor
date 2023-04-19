vsim -gui work.processor
add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/rst
add wave -position end  sim:/processor/IN_Port
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
force -freeze sim:/processor/rst 1 0
mem load -i {C:/Users/Mark/Desktop/Computer Architecture Project/Computer-Architecture-Project/test (new)/memory_file.mem} /processor/Internal_Fetch_Stage/Internal_Instruction_Memory/instruction_cache
