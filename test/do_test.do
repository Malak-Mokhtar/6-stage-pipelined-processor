vsim -gui work.processor
#basics
add wave -position end  sim:/processor/clk
add wave -position end  sim:/processor/rst
add wave -position end  sim:/processor/Internal_Fetch_Stage/Internal_PC/Read_Address
add wave -position end  sim:/processor/Internal_Decode_Stage/Internal_Register_File/register_data
# IN PORT
add wave -position end  sim:/processor/IN_Port

#Memory
add wave -position end  sim:/processor/Internal_Memory_Stages/Data_memory_MAP/MemRead_en
add wave -position end  sim:/processor/Internal_Memory_Stages/Data_memory_MAP/Address
add wave -position end  sim:/processor/Internal_Memory_Stages/Data_memory_MAP/Read_Data
add wave -position end  sim:/processor/Internal_Memory_Stages/Data_memory_MAP/memory_data

#FLAGS
add wave -position end  sim:/processor/Internal_Execute_Stage/CF_MAP/CF_OUT
add wave -position end  sim:/processor/Internal_Execute_Stage/ZF_MAP/ZF_OUT
add wave -position end  sim:/processor/Internal_Execute_Stage/NF_MAP/NF_OUT

add wave -position end  sim:/processor/Internal_FD_Register/Inst
add wave -position end  sim:/processor/Internal_FD_Register/FD_Inst_out



#configuring the clock
force -freeze sim:/processor/clk 1 0, 0 {50 ps} -r 100
#resetting
force -freeze sim:/processor/rst 1 0
run
# adding instructions to Instruction memory 
mem load -i {C:/Users/Mark/Desktop/Computer Architecture Project/Computer-Architecture-Project/test (new)/memory_file.mem} /processor/Internal_Fetch_Stage/Internal_Instruction_Memory/instruction_cache

#load starting address and zeros to data memory
mem load -i {C:/Users/Mark/Desktop/Computer Architecture Project/Computer-Architecture-Project/test/zeros.mem} /processor/Internal_Memory_Stages/Data_memory_MAP/memory_data


force -freeze sim:/processor/IN_Port x\"fffe\" 0
force -freeze sim:/processor/rst 0 0
run
#IN R5  
run
##################################
#NOP
run
#NOP
run
#NOP
run
#NOP
run
#################################
#INC R5,R5
run
#################################
#NOP
run
#NOP
run
#NOP
run
#NOP
run
run
################################
#INC R5,R5
run
################################
# IN port => 0001
force -freeze sim:/processor/IN_Port x\"0001\" 0
#IN R1
run
#################################
force -freeze sim:/processor/IN_Port x\"000F\" 0
#IN R2
run
#################################
force -freeze sim:/processor/IN_Port x\"00C8\" 0
#IN R3
run
#################################
force -freeze sim:/processor/IN_Port x\"001F\" 0
#IN R4
run
#################################
force -freeze sim:/processor/IN_Port x\"00FC\" 0
#IN R5
run
#################################
#NOP
run
#NOP
run
##################################
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
run
