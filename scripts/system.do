onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/halt
add wave -noupdate -group Navigation -color Gold /system_tb/DUT/CPU/DP/DC/Instruction
add wave -noupdate -group Navigation -color Gold /system_tb/DUT/CPU/DP/DC/op
add wave -noupdate -group Navigation -color Gold /system_tb/DUT/CPU/DP/DC/rs
add wave -noupdate -group Navigation -color Gold /system_tb/DUT/CPU/DP/DC/rt
add wave -noupdate -group Navigation -color Gold /system_tb/DUT/CPU/DP/DC/rd
add wave -noupdate -group Navigation -color Gold /system_tb/DUT/CPU/DP/DC/imm
add wave -noupdate -group Navigation -color Gold /system_tb/DUT/CPU/DP/DC/func
add wave -noupdate -group Navigation -color Gold /system_tb/DUT/CPU/DP/DC/Imm_Ext
add wave -noupdate -group Fetch/Decode -group pcif /system_tb/DUT/CPU/DP/FT/pcif/PC
add wave -noupdate -group Fetch/Decode -group pcif /system_tb/DUT/CPU/DP/FT/pcif/next_PC
add wave -noupdate -group Fetch/Decode -group pcif /system_tb/DUT/CPU/DP/FT/pcif/EN
add wave -noupdate -group Fetch/Decode -color {Cornflower Blue} /system_tb/DUT/CPU/DP/ftif/ihit
add wave -noupdate -group Fetch/Decode -color {Cornflower Blue} /system_tb/DUT/CPU/DP/ftif/dhit
add wave -noupdate -group Fetch/Decode -color {Cornflower Blue} /system_tb/DUT/CPU/DP/ftif/flush
add wave -noupdate -group Fetch/Decode -color {Cornflower Blue} /system_tb/DUT/CPU/DP/ftif/freeze
add wave -noupdate -group Fetch/Decode -color {Cornflower Blue} /system_tb/DUT/CPU/DP/ftif/imemload
add wave -noupdate -group Fetch/Decode -color {Cornflower Blue} /system_tb/DUT/CPU/DP/ftif/fetch_p
add wave -noupdate -group Fetch/Decode -color {Cornflower Blue} /system_tb/DUT/CPU/DP/ftif/imemREN
add wave -noupdate -group Fetch/Decode -color {Cornflower Blue} /system_tb/DUT/CPU/DP/ftif/imemaddr
add wave -noupdate -group Fetch/Decode -color {Cornflower Blue} /system_tb/DUT/CPU/DP/ftif/BranchTaken
add wave -noupdate -group Fetch/Decode -color {Cornflower Blue} /system_tb/DUT/CPU/DP/ftif/BranchAddr
add wave -noupdate -group Fetch/Decode -color {Cornflower Blue} /system_tb/DUT/CPU/DP/ftif/JumpSel
add wave -noupdate -group Fetch/Decode -color {Cornflower Blue} /system_tb/DUT/CPU/DP/ftif/JumpAddr
add wave -noupdate -group Fetch/Decode -color {Cornflower Blue} /system_tb/DUT/CPU/DP/ftif/port_a
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/opcode
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/func
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/ALUctr
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/ihit
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/dhit
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/zero
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/jal
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/RegDst
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/RegWEN
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/ALUSrc
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/BEQ
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/BNE
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/halt
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/iREN
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/dREN
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/dWEN
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/MemtoReg
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/JumpSel
add wave -noupdate -group Decode/Execute -group cuif /system_tb/DUT/CPU/DP/DC/cuif/ExtOP
add wave -noupdate -group Decode/Execute -group rfif /system_tb/DUT/CPU/DP/DC/rfif/WEN
add wave -noupdate -group Decode/Execute -group rfif /system_tb/DUT/CPU/DP/DC/rfif/wsel
add wave -noupdate -group Decode/Execute -group rfif /system_tb/DUT/CPU/DP/DC/rfif/rsel1
add wave -noupdate -group Decode/Execute -group rfif /system_tb/DUT/CPU/DP/DC/rfif/rsel2
add wave -noupdate -group Decode/Execute -group rfif /system_tb/DUT/CPU/DP/DC/rfif/wdat
add wave -noupdate -group Decode/Execute -group rfif /system_tb/DUT/CPU/DP/DC/rfif/rdat1
add wave -noupdate -group Decode/Execute -group rfif /system_tb/DUT/CPU/DP/DC/rfif/rdat2
add wave -noupdate -group Decode/Execute -color {Cornflower Blue} /system_tb/DUT/CPU/DP/dcif/ihit
add wave -noupdate -group Decode/Execute -color {Cornflower Blue} /system_tb/DUT/CPU/DP/dcif/dhit
add wave -noupdate -group Decode/Execute -color {Cornflower Blue} /system_tb/DUT/CPU/DP/dcif/flush
add wave -noupdate -group Decode/Execute -color {Cornflower Blue} /system_tb/DUT/CPU/DP/dcif/freeze
add wave -noupdate -group Decode/Execute -color {Cornflower Blue} /system_tb/DUT/CPU/DP/dcif/fetch_p
add wave -noupdate -group Decode/Execute -color {Cornflower Blue} /system_tb/DUT/CPU/DP/dcif/writeback_p
add wave -noupdate -group Decode/Execute -color {Cornflower Blue} /system_tb/DUT/CPU/DP/dcif/decode_p
add wave -noupdate -group Decode/Execute -color {Cornflower Blue} /system_tb/DUT/CPU/DP/dcif/porta
add wave -noupdate -group Decode/Execute -color {Cornflower Blue} /system_tb/DUT/CPU/DP/dcif/JumpSel
add wave -noupdate -group Decode/Execute -color {Cornflower Blue} /system_tb/DUT/CPU/DP/dcif/JumpAddr
add wave -noupdate -group Decode/Execute -color {Cornflower Blue} /system_tb/DUT/CPU/DP/dcif/BranchAddr
add wave -noupdate -group Decode/Execute -color {Cornflower Blue} /system_tb/DUT/CPU/DP/dcif/BranchTaken
add wave -noupdate -group Execute/Memory -group aluif /system_tb/DUT/CPU/DP/EX/aluif/ALUOP
add wave -noupdate -group Execute/Memory -group aluif /system_tb/DUT/CPU/DP/EX/aluif/porta
add wave -noupdate -group Execute/Memory -group aluif /system_tb/DUT/CPU/DP/EX/aluif/portb
add wave -noupdate -group Execute/Memory -group aluif /system_tb/DUT/CPU/DP/EX/aluif/oport
add wave -noupdate -group Execute/Memory -group aluif /system_tb/DUT/CPU/DP/EX/aluif/negative
add wave -noupdate -group Execute/Memory -group aluif /system_tb/DUT/CPU/DP/EX/aluif/zero
add wave -noupdate -group Execute/Memory -group aluif /system_tb/DUT/CPU/DP/EX/aluif/overflow
add wave -noupdate -group Execute/Memory -color {Cornflower Blue} /system_tb/DUT/CPU/DP/exif/ihit
add wave -noupdate -group Execute/Memory -color {Cornflower Blue} /system_tb/DUT/CPU/DP/exif/dhit
add wave -noupdate -group Execute/Memory -color {Cornflower Blue} /system_tb/DUT/CPU/DP/exif/flush
add wave -noupdate -group Execute/Memory -color {Cornflower Blue} /system_tb/DUT/CPU/DP/exif/freeze
add wave -noupdate -group Execute/Memory -color {Cornflower Blue} /system_tb/DUT/CPU/DP/exif/decode_p
add wave -noupdate -group Execute/Memory -color {Cornflower Blue} /system_tb/DUT/CPU/DP/exif/execute_p
add wave -noupdate -group Memory/Writeback -color {Cornflower Blue} /system_tb/DUT/CPU/DP/mmif/ihit
add wave -noupdate -group Memory/Writeback -color {Cornflower Blue} /system_tb/DUT/CPU/DP/mmif/dhit
add wave -noupdate -group Memory/Writeback -color {Cornflower Blue} /system_tb/DUT/CPU/DP/mmif/flush
add wave -noupdate -group Memory/Writeback -color {Cornflower Blue} /system_tb/DUT/CPU/DP/mmif/freeze
add wave -noupdate -group Memory/Writeback -color {Cornflower Blue} /system_tb/DUT/CPU/DP/mmif/execute_p
add wave -noupdate -group Memory/Writeback -color {Cornflower Blue} /system_tb/DUT/CPU/DP/mmif/dmemload
add wave -noupdate -group Memory/Writeback -color {Cornflower Blue} /system_tb/DUT/CPU/DP/mmif/memory_p
add wave -noupdate -group Memory/Writeback -color {Cornflower Blue} /system_tb/DUT/CPU/DP/mmif/dmemaddr
add wave -noupdate -group Memory/Writeback -color {Cornflower Blue} /system_tb/DUT/CPU/DP/mmif/dmemstore
add wave -noupdate -group Memory/Writeback -color {Cornflower Blue} /system_tb/DUT/CPU/DP/mmif/dmemREN
add wave -noupdate -group Memory/Writeback -color {Cornflower Blue} /system_tb/DUT/CPU/DP/mmif/dmemWEN
add wave -noupdate -group Datapath -group huif /system_tb/DUT/CPU/DP/huif/flush
add wave -noupdate -group Datapath -group huif /system_tb/DUT/CPU/DP/huif/freeze
add wave -noupdate -group Datapath -group huif /system_tb/DUT/CPU/DP/huif/memread_dc
add wave -noupdate -group Datapath -group huif /system_tb/DUT/CPU/DP/huif/memread_ex
add wave -noupdate -group Datapath -group huif /system_tb/DUT/CPU/DP/huif/Rt_dc
add wave -noupdate -group Datapath -group huif /system_tb/DUT/CPU/DP/huif/Rs_ft
add wave -noupdate -group Datapath -group huif /system_tb/DUT/CPU/DP/huif/Rt_ft
add wave -noupdate -group Datapath -group huif /system_tb/DUT/CPU/DP/huif/JumpSel
add wave -noupdate -group Datapath -group huif /system_tb/DUT/CPU/DP/huif/BranchTaken
add wave -noupdate -group Datapath -group fwif /system_tb/DUT/CPU/DP/FU/fwif/Rs_dc
add wave -noupdate -group Datapath -group fwif /system_tb/DUT/CPU/DP/FU/fwif/Rt_dc
add wave -noupdate -group Datapath -group fwif /system_tb/DUT/CPU/DP/FU/fwif/Rw_ex
add wave -noupdate -group Datapath -group fwif /system_tb/DUT/CPU/DP/FU/fwif/execute_data_in
add wave -noupdate -group Datapath -group fwif /system_tb/DUT/CPU/DP/FU/fwif/Rw_wb
add wave -noupdate -group Datapath -group fwif /system_tb/DUT/CPU/DP/FU/fwif/writeback_data_in
add wave -noupdate -group Datapath -group fwif /system_tb/DUT/CPU/DP/FU/fwif/execute_data_out
add wave -noupdate -group Datapath -group fwif /system_tb/DUT/CPU/DP/FU/fwif/writeback_data_out
add wave -noupdate -group Datapath -group fwif /system_tb/DUT/CPU/DP/FU/fwif/port_a_control
add wave -noupdate -group Datapath -group fwif /system_tb/DUT/CPU/DP/FU/fwif/port_b_control
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/imemREN
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/flushed
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate /system_tb/DUT/CPU/DP/DC/RF/registers
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {556709 ps} 0}
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
WaveRestoreZoom {0 ps} {881 ns}
