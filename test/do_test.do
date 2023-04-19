vsim -gui work.processor
add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/rst
add wave -position end  sim:/processor/IN_Port
add wave -position end  sim:/processor/Internal_Memory_Stages/Data_memory_MAP/memory_data

#configuring the clock
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
#resetting
force -freeze sim:/processor/rst 1 0
run
# adding instructions to Instruction memory 
mem load -i {C:/Users/Mark/Desktop/Computer Architecture Project/Computer-Architecture-Project/test (new)/memory_file.mem} /processor/Internal_Fetch_Stage/Internal_Instruction_Memory/instruction_cache

#load starting address and zeros to data memory
mem load -i {C:/Users/Mark/Desktop/Computer Architecture Project/Computer-Architecture-Project/test/zeros.mem} /processor/Internal_Memory_Stages/Data_memory_MAP/memory_data

#IN R5  
force -freeze sim:/processor/IN_Port x\"fffe\" 0
force -freeze sim:/processor/rst 0 0
run
#INC R5,R5 
run
#INC R5,R5 
run
