onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/op
add wave -noupdate /system_tb/DUT/CPU/halt
add wave -noupdate -expand -group Fetch/Decode /system_tb/DUT/CPU/DP/fdif/stall
add wave -noupdate -expand -group Fetch/Decode /system_tb/DUT/CPU/DP/fdif/flush
add wave -noupdate -expand -group Fetch/Decode /system_tb/DUT/CPU/DP/fdif/imemload_in
add wave -noupdate -expand -group Fetch/Decode /system_tb/DUT/CPU/DP/fdif/imemload
add wave -noupdate -expand -group Fetch/Decode /system_tb/DUT/CPU/DP/fdif/NPC_in
add wave -noupdate -expand -group Fetch/Decode /system_tb/DUT/CPU/DP/fdif/NPC
add wave -noupdate -expand -group Fetch/Decode /system_tb/DUT/CPU/DP/fdif/ihit
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/stall
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/flush
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/ALUctr_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/ALUctr
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/jal_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/jal
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/RegDst_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/RegDst
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/RegWr_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/RegWr
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/ALUSrc_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/ALUSrc
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/BEQ_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/BEQ
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/BNE_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/BNE
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/halt_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/halt
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/dREN_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/dREN
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/dWEN_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/dWEN
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/MemtoReg_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/MemtoReg
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/Rd_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/Rd
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/Rt_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/Rt
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/port_a_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/port_b_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/Imm_Ext_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/port_a
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/port_b
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/Imm_Ext
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/JumpAddr_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/JumpAddr
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/NPC_in
add wave -noupdate -group Decode/Execute /system_tb/DUT/CPU/DP/deif/NPC
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/stall
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/flush
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/jal_in
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/jal
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/RegDst_in
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/RegDst
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/RegWr_in
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/RegWr
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/halt_in
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/halt
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/dREN_in
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/dREN
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/dWEN_in
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/dWEN
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/MemtoReg_in
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/MemtoReg
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/Rd_in
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/Rd
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/Rt_in
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/Rt
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/dmemstore_in
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/port_o_in
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/dmemstore
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/port_o
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/dmemload
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/LUI_in
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/LUI
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/NPC_in
add wave -noupdate -group Execute/Memory /system_tb/DUT/CPU/DP/emif/NPC
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/stall
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/flush
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/ALUctr_in
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/ALUctr
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/jal_in
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/jal
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/RegDst_in
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/RegDst
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/RegWr_in
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/RegWr
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/halt_in
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/halt
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/MemtoReg_in
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/MemtoReg
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/Rd_in
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/Rd
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/Rt_in
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/Rt
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/port_o_in
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/dmemload_in
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/port_o
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/dmemload
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/LUI_in
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/LUI
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/NPC_in
add wave -noupdate -group Memory/Writeback /system_tb/DUT/CPU/DP/mwif/NPC
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
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
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
WaveRestoreZoom {0 ps} {454 ns}
