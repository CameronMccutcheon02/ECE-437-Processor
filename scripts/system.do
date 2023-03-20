onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/halt
add wave -noupdate -expand -group Navigation -color Gold /system_tb/DUT/CPU/DP/DC/Instruction
add wave -noupdate -expand -group Navigation -color Gold /system_tb/DUT/CPU/DP/DC/op
add wave -noupdate -expand -group Navigation -color Gold /system_tb/DUT/CPU/DP/DC/rs
add wave -noupdate -expand -group Navigation -color Gold /system_tb/DUT/CPU/DP/DC/rt
add wave -noupdate -expand -group Navigation -color Gold /system_tb/DUT/CPU/DP/DC/rd
add wave -noupdate -expand -group Navigation -color Gold /system_tb/DUT/CPU/DP/DC/imm
add wave -noupdate -expand -group Navigation -color Gold /system_tb/DUT/CPU/DP/DC/func
add wave -noupdate -expand -group Navigation -color Gold /system_tb/DUT/CPU/DP/DC/Imm_Ext
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group ftif /system_tb/DUT/CPU/DP/FT/ftif/ihit
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group ftif /system_tb/DUT/CPU/DP/FT/ftif/dhit
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group ftif /system_tb/DUT/CPU/DP/FT/ftif/flush
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group ftif /system_tb/DUT/CPU/DP/FT/ftif/freeze
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group ftif /system_tb/DUT/CPU/DP/FT/ftif/imemload
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group ftif /system_tb/DUT/CPU/DP/FT/ftif/fetch_p
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group ftif /system_tb/DUT/CPU/DP/FT/ftif/imemREN
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group ftif /system_tb/DUT/CPU/DP/FT/ftif/imemaddr
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group ftif /system_tb/DUT/CPU/DP/FT/ftif/BranchTaken
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group ftif /system_tb/DUT/CPU/DP/FT/ftif/BranchAddr
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group ftif /system_tb/DUT/CPU/DP/FT/ftif/JumpSel
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group ftif /system_tb/DUT/CPU/DP/FT/ftif/JumpAddr
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group ftif /system_tb/DUT/CPU/DP/FT/ftif/port_a
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group bpif /system_tb/DUT/CPU/DP/FT/bpif/PC_Current
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group bpif /system_tb/DUT/CPU/DP/FT/bpif/PC_mem
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group bpif /system_tb/DUT/CPU/DP/FT/bpif/branch_addr_mem
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group bpif /system_tb/DUT/CPU/DP/FT/bpif/branch_mispredict
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group bpif /system_tb/DUT/CPU/DP/FT/bpif/BEQ
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group bpif /system_tb/DUT/CPU/DP/FT/bpif/BNE
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group bpif /system_tb/DUT/CPU/DP/FT/bpif/branch_taken
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group bpif /system_tb/DUT/CPU/DP/FT/bpif/branch_target
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group pcif /system_tb/DUT/CPU/DP/FT/pcif/PC
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group pcif /system_tb/DUT/CPU/DP/FT/pcif/next_PC
add wave -noupdate -group Datapath -group Fetch/Decode -expand -group pcif /system_tb/DUT/CPU/DP/FT/pcif/EN
add wave -noupdate -group Datapath -group Decode/Execute -expand -group dcif /system_tb/DUT/CPU/DP/DC/dcif/ihit
add wave -noupdate -group Datapath -group Decode/Execute -expand -group dcif /system_tb/DUT/CPU/DP/DC/dcif/dhit
add wave -noupdate -group Datapath -group Decode/Execute -expand -group dcif /system_tb/DUT/CPU/DP/DC/dcif/flush
add wave -noupdate -group Datapath -group Decode/Execute -expand -group dcif /system_tb/DUT/CPU/DP/DC/dcif/freeze
add wave -noupdate -group Datapath -group Decode/Execute -expand -group dcif /system_tb/DUT/CPU/DP/DC/dcif/fetch_p
add wave -noupdate -group Datapath -group Decode/Execute -expand -group dcif /system_tb/DUT/CPU/DP/DC/dcif/writeback_p
add wave -noupdate -group Datapath -group Decode/Execute -expand -group dcif /system_tb/DUT/CPU/DP/DC/dcif/decode_p
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/opcode
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/func
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/ALUctr
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/ihit
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/dhit
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/zero
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/jal
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/RegDst
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/RegWEN
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/ALUSrc
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/BEQ
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/BNE
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/halt
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/iREN
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/dREN
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/dWEN
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/MemtoReg
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/JumpSel
add wave -noupdate -group Datapath -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/ExtOP
add wave -noupdate -group Datapath -group Decode/Execute -group rfif /system_tb/DUT/CPU/DP/DC/rfif/WEN
add wave -noupdate -group Datapath -group Decode/Execute -group rfif /system_tb/DUT/CPU/DP/DC/rfif/wsel
add wave -noupdate -group Datapath -group Decode/Execute -group rfif /system_tb/DUT/CPU/DP/DC/rfif/rsel1
add wave -noupdate -group Datapath -group Decode/Execute -group rfif /system_tb/DUT/CPU/DP/DC/rfif/rsel2
add wave -noupdate -group Datapath -group Decode/Execute -group rfif /system_tb/DUT/CPU/DP/DC/rfif/wdat
add wave -noupdate -group Datapath -group Decode/Execute -group rfif /system_tb/DUT/CPU/DP/DC/rfif/rdat1
add wave -noupdate -group Datapath -group Decode/Execute -group rfif /system_tb/DUT/CPU/DP/DC/rfif/rdat2
add wave -noupdate -group Datapath -group Decode/Execute /system_tb/DUT/CPU/DP/DC/RF/registers
add wave -noupdate -group Datapath -group Execute/Memory -expand -group exif /system_tb/DUT/CPU/DP/EX/exif/ihit
add wave -noupdate -group Datapath -group Execute/Memory -expand -group exif /system_tb/DUT/CPU/DP/EX/exif/dhit
add wave -noupdate -group Datapath -group Execute/Memory -expand -group exif /system_tb/DUT/CPU/DP/EX/exif/flush
add wave -noupdate -group Datapath -group Execute/Memory -expand -group exif /system_tb/DUT/CPU/DP/EX/exif/freeze
add wave -noupdate -group Datapath -group Execute/Memory -expand -group exif /system_tb/DUT/CPU/DP/EX/exif/decode_p
add wave -noupdate -group Datapath -group Execute/Memory -expand -group exif /system_tb/DUT/CPU/DP/EX/exif/port_a_forwarding_control
add wave -noupdate -group Datapath -group Execute/Memory -expand -group exif /system_tb/DUT/CPU/DP/EX/exif/port_b_forwarding_control
add wave -noupdate -group Datapath -group Execute/Memory -expand -group exif /system_tb/DUT/CPU/DP/EX/exif/FW_execute_data
add wave -noupdate -group Datapath -group Execute/Memory -expand -group exif /system_tb/DUT/CPU/DP/EX/exif/FW_writeback_data
add wave -noupdate -group Datapath -group Execute/Memory -expand -group exif /system_tb/DUT/CPU/DP/EX/exif/execute_p
add wave -noupdate -group Datapath -group Execute/Memory -group aluif /system_tb/DUT/CPU/DP/EX/aluif/ALUOP
add wave -noupdate -group Datapath -group Execute/Memory -group aluif /system_tb/DUT/CPU/DP/EX/aluif/porta
add wave -noupdate -group Datapath -group Execute/Memory -group aluif /system_tb/DUT/CPU/DP/EX/aluif/portb
add wave -noupdate -group Datapath -group Execute/Memory -group aluif /system_tb/DUT/CPU/DP/EX/aluif/oport
add wave -noupdate -group Datapath -group Execute/Memory -group aluif /system_tb/DUT/CPU/DP/EX/aluif/negative
add wave -noupdate -group Datapath -group Execute/Memory -group aluif /system_tb/DUT/CPU/DP/EX/aluif/zero
add wave -noupdate -group Datapath -group Execute/Memory -group aluif /system_tb/DUT/CPU/DP/EX/aluif/overflow
add wave -noupdate -group Datapath -group Memory/Writeback -expand -group mmif /system_tb/DUT/CPU/DP/MM/mmif/ihit
add wave -noupdate -group Datapath -group Memory/Writeback -expand -group mmif /system_tb/DUT/CPU/DP/MM/mmif/dhit
add wave -noupdate -group Datapath -group Memory/Writeback -expand -group mmif /system_tb/DUT/CPU/DP/MM/mmif/flush
add wave -noupdate -group Datapath -group Memory/Writeback -expand -group mmif /system_tb/DUT/CPU/DP/MM/mmif/freeze
add wave -noupdate -group Datapath -group Memory/Writeback -expand -group mmif /system_tb/DUT/CPU/DP/MM/mmif/execute_p
add wave -noupdate -group Datapath -group Memory/Writeback -expand -group mmif /system_tb/DUT/CPU/DP/MM/mmif/dmemload
add wave -noupdate -group Datapath -group Memory/Writeback -expand -group mmif /system_tb/DUT/CPU/DP/MM/mmif/memory_p
add wave -noupdate -group Datapath -group Memory/Writeback -expand -group mmif /system_tb/DUT/CPU/DP/MM/mmif/dmemaddr
add wave -noupdate -group Datapath -group Memory/Writeback -expand -group mmif /system_tb/DUT/CPU/DP/MM/mmif/dmemstore
add wave -noupdate -group Datapath -group Memory/Writeback -expand -group mmif /system_tb/DUT/CPU/DP/MM/mmif/dmemREN
add wave -noupdate -group Datapath -group Memory/Writeback -expand -group mmif /system_tb/DUT/CPU/DP/MM/mmif/dmemWEN
add wave -noupdate -group Datapath -group Memory/Writeback -expand -group mmif /system_tb/DUT/CPU/DP/MM/mmif/BranchAddr
add wave -noupdate -group Datapath -group Memory/Writeback -expand -group mmif /system_tb/DUT/CPU/DP/MM/mmif/JumpAddr
add wave -noupdate -group Datapath -group Memory/Writeback -expand -group mmif /system_tb/DUT/CPU/DP/MM/mmif/port_a
add wave -noupdate -group Datapath -group Memory/Writeback -expand -group mmif /system_tb/DUT/CPU/DP/MM/mmif/JumpSel
add wave -noupdate -group Datapath -group Memory/Writeback -expand -group mmif /system_tb/DUT/CPU/DP/MM/mmif/BranchTaken
add wave -noupdate -group Datapath -group Memory/Writeback -expand -group mmif /system_tb/DUT/CPU/DP/MM/mmif/forwarding_unit_data
add wave -noupdate -group Datapath -group {DP Outputs} -group huif /system_tb/DUT/CPU/DP/HU/huif/flush
add wave -noupdate -group Datapath -group {DP Outputs} -group huif /system_tb/DUT/CPU/DP/HU/huif/freeze
add wave -noupdate -group Datapath -group {DP Outputs} -group huif /system_tb/DUT/CPU/DP/HU/huif/memread_dc
add wave -noupdate -group Datapath -group {DP Outputs} -group huif /system_tb/DUT/CPU/DP/HU/huif/memread_ex
add wave -noupdate -group Datapath -group {DP Outputs} -group huif /system_tb/DUT/CPU/DP/HU/huif/Rs_ft
add wave -noupdate -group Datapath -group {DP Outputs} -group huif /system_tb/DUT/CPU/DP/HU/huif/Rt_dc
add wave -noupdate -group Datapath -group {DP Outputs} -group huif /system_tb/DUT/CPU/DP/HU/huif/Rt_ex
add wave -noupdate -group Datapath -group {DP Outputs} -group huif /system_tb/DUT/CPU/DP/HU/huif/Rt_ft
add wave -noupdate -group Datapath -group {DP Outputs} -group huif /system_tb/DUT/CPU/DP/HU/huif/Rd_dc
add wave -noupdate -group Datapath -group {DP Outputs} -group huif /system_tb/DUT/CPU/DP/HU/huif/Rd_ex
add wave -noupdate -group Datapath -group {DP Outputs} -group huif /system_tb/DUT/CPU/DP/HU/huif/BEQ
add wave -noupdate -group Datapath -group {DP Outputs} -group huif /system_tb/DUT/CPU/DP/HU/huif/BNE
add wave -noupdate -group Datapath -group {DP Outputs} -group huif /system_tb/DUT/CPU/DP/HU/huif/zero
add wave -noupdate -group Datapath -group {DP Outputs} -group huif /system_tb/DUT/CPU/DP/HU/huif/JumpSel
add wave -noupdate -group Datapath -group {DP Outputs} -group fuif /system_tb/DUT/CPU/DP/FU/fwif/Rs_dc
add wave -noupdate -group Datapath -group {DP Outputs} -group fuif /system_tb/DUT/CPU/DP/FU/fwif/Rt_dc
add wave -noupdate -group Datapath -group {DP Outputs} -group fuif /system_tb/DUT/CPU/DP/FU/fwif/Rw_ex
add wave -noupdate -group Datapath -group {DP Outputs} -group fuif /system_tb/DUT/CPU/DP/FU/fwif/execute_data_in
add wave -noupdate -group Datapath -group {DP Outputs} -group fuif /system_tb/DUT/CPU/DP/FU/fwif/Rw_wb
add wave -noupdate -group Datapath -group {DP Outputs} -group fuif /system_tb/DUT/CPU/DP/FU/fwif/writeback_data_in
add wave -noupdate -group Datapath -group {DP Outputs} -group fuif /system_tb/DUT/CPU/DP/FU/fwif/execute_data_out
add wave -noupdate -group Datapath -group {DP Outputs} -group fuif /system_tb/DUT/CPU/DP/FU/fwif/writeback_data_out
add wave -noupdate -group Datapath -group {DP Outputs} -group fuif /system_tb/DUT/CPU/DP/FU/fwif/port_a_control
add wave -noupdate -group Datapath -group {DP Outputs} -group fuif /system_tb/DUT/CPU/DP/FU/fwif/port_b_control
add wave -noupdate -group Datapath -group {DP Outputs} /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate -group Datapath -group {DP Outputs} /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate -group Datapath -group {DP Outputs} /system_tb/DUT/CPU/DP/dpif/imemREN
add wave -noupdate -group Datapath -group {DP Outputs} /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate -group Datapath -group {DP Outputs} /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate -group Datapath -group {DP Outputs} /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate -group Datapath -group {DP Outputs} /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate -group Datapath -group {DP Outputs} /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate -group Datapath -group {DP Outputs} /system_tb/DUT/CPU/DP/dpif/flushed
add wave -noupdate -group Datapath -group {DP Outputs} /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate -group Datapath -group {DP Outputs} /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate -group Datapath -group {DP Outputs} /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/DC/RF/registers
add wave -noupdate -group Datapath -group {Branch Predictor} {/system_tb/DUT/CPU/DP/FT/BP/BTB[16]}
add wave -noupdate -group Datapath -group {Branch Predictor} {/system_tb/DUT/CPU/DP/FT/BP/BTB[15]}
add wave -noupdate -group Datapath -group {Branch Predictor} {/system_tb/DUT/CPU/DP/FT/BP/BTB[14]}
add wave -noupdate -group Datapath -group {Branch Predictor} {/system_tb/DUT/CPU/DP/FT/BP/BTB[13]}
add wave -noupdate -group Datapath -group {Branch Predictor} {/system_tb/DUT/CPU/DP/FT/BP/BTB[12]}
add wave -noupdate -group Datapath -group {Branch Predictor} {/system_tb/DUT/CPU/DP/FT/BP/BTB[11]}
add wave -noupdate -group Datapath -group {Branch Predictor} {/system_tb/DUT/CPU/DP/FT/BP/BTB[10]}
add wave -noupdate -group Datapath -group {Branch Predictor} {/system_tb/DUT/CPU/DP/FT/BP/BTB[9]}
add wave -noupdate -group Datapath -group {Branch Predictor} {/system_tb/DUT/CPU/DP/FT/BP/BTB[8]}
add wave -noupdate -group Datapath -group {Branch Predictor} {/system_tb/DUT/CPU/DP/FT/BP/BTB[7]}
add wave -noupdate -group Datapath -group {Branch Predictor} {/system_tb/DUT/CPU/DP/FT/BP/BTB[6]}
add wave -noupdate -group Datapath -group {Branch Predictor} {/system_tb/DUT/CPU/DP/FT/BP/BTB[5]}
add wave -noupdate -group Datapath -group {Branch Predictor} {/system_tb/DUT/CPU/DP/FT/BP/BTB[4]}
add wave -noupdate -group Datapath -group {Branch Predictor} {/system_tb/DUT/CPU/DP/FT/BP/BTB[3]}
add wave -noupdate -group Datapath -group {Branch Predictor} {/system_tb/DUT/CPU/DP/FT/BP/BTB[2]}
add wave -noupdate -group Datapath -group {Branch Predictor} {/system_tb/DUT/CPU/DP/FT/BP/BTB[1]}
add wave -noupdate -group Datapath -group {Branch Predictor} {/system_tb/DUT/CPU/DP/FT/BP/BTB[0]}
add wave -noupdate -group DCACHE -expand -group dcif /system_tb/DUT/CPU/dcif/halt
add wave -noupdate -group DCACHE -expand -group dcif /system_tb/DUT/CPU/dcif/ihit
add wave -noupdate -group DCACHE -expand -group dcif /system_tb/DUT/CPU/dcif/imemREN
add wave -noupdate -group DCACHE -expand -group dcif /system_tb/DUT/CPU/dcif/imemload
add wave -noupdate -group DCACHE -expand -group dcif /system_tb/DUT/CPU/dcif/imemaddr
add wave -noupdate -group DCACHE -expand -group dcif /system_tb/DUT/CPU/dcif/dhit
add wave -noupdate -group DCACHE -expand -group dcif /system_tb/DUT/CPU/dcif/datomic
add wave -noupdate -group DCACHE -expand -group dcif /system_tb/DUT/CPU/dcif/dmemREN
add wave -noupdate -group DCACHE -expand -group dcif /system_tb/DUT/CPU/dcif/dmemWEN
add wave -noupdate -group DCACHE -expand -group dcif /system_tb/DUT/CPU/dcif/flushed
add wave -noupdate -group DCACHE -expand -group dcif /system_tb/DUT/CPU/dcif/dmemload
add wave -noupdate -group DCACHE -expand -group dcif /system_tb/DUT/CPU/dcif/dmemstore
add wave -noupdate -group DCACHE -expand -group dcif /system_tb/DUT/CPU/dcif/dmemaddr
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/cur_state
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/nxt_state
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/dcache
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/addr
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/datapath_tag
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/datapath_index
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/datapath_block_offset
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/datapath_byte_offset
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/row
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/nxt_row
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/hit_count
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/miss
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/valid
add wave -noupdate -group DCACHE /system_tb/DUT/CPU/CM/DCACHE/dirty
add wave -noupdate -expand -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/CLK
add wave -noupdate -expand -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/nRST
add wave -noupdate -expand -group ICACHE -expand /system_tb/DUT/CPU/CM/ICACHE/icache
add wave -noupdate -expand -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/tag
add wave -noupdate -expand -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/cif/iaddr
add wave -noupdate -expand -group ICACHE /system_tb/DUT/CPU/CM/ICACHE/index
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/dcif/ihit
add wave -noupdate -expand -group syif /system_tb/DUT/syif/tbCTRL
add wave -noupdate -expand -group syif /system_tb/DUT/syif/halt
add wave -noupdate -expand -group syif /system_tb/DUT/syif/WEN
add wave -noupdate -expand -group syif /system_tb/DUT/syif/REN
add wave -noupdate -expand -group syif /system_tb/DUT/syif/addr
add wave -noupdate -expand -group syif /system_tb/DUT/syif/store
add wave -noupdate -expand -group syif /system_tb/DUT/syif/load
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/iwait
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/dwait
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/iREN
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/dREN
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/dWEN
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/iload
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/dload
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/dstore
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/iaddr
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/daddr
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ccwait
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ccinv
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ccwrite
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/cctrans
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ccsnoopaddr
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramWEN
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramREN
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramstate
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramaddr
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramstore
add wave -noupdate -group ccif /system_tb/DUT/CPU/ccif/ramload
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/cif/iwait
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/cif/dwait
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/cif/iREN
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/cif/dREN
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/cif/dWEN
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/cif/iload
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/cif/dload
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/cif/dstore
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/cif/iaddr
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/cif/daddr
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/cif/ccwait
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/cif/ccinv
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/cif/ccwrite
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/cif/cctrans
add wave -noupdate /system_tb/DUT/CPU/CM/ICACHE/cif/ccsnoopaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {708378 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 1
configure wave -snapdistance 10
configure wave -datasetprefix 0
configure wave -rowmargin 4
configure wave -childrowmargin 2
configure wave -gridoffset 0
configure wave -gridperiod 1
configure wave -griddelta 40
configure wave -timeline 0
configure wave -timelineunits ns
update
WaveRestoreZoom {0 ps} {2136 ns}
