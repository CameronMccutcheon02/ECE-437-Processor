onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /datapath_tb/PROG/tb_test_case
add wave -noupdate /datapath_tb/PROG/tb_test_case_num
add wave -noupdate /datapath_tb/CLK
add wave -noupdate /datapath_tb/nRST
add wave -noupdate -expand -group DPIF /datapath_tb/dpif/halt
add wave -noupdate -expand -group DPIF /datapath_tb/dpif/ihit
add wave -noupdate -expand -group DPIF /datapath_tb/dpif/imemREN
add wave -noupdate -expand -group DPIF /datapath_tb/dpif/imemload
add wave -noupdate -expand -group DPIF /datapath_tb/dpif/imemaddr
add wave -noupdate -expand -group DPIF /datapath_tb/dpif/dhit
add wave -noupdate -expand -group DPIF /datapath_tb/dpif/datomic
add wave -noupdate -expand -group DPIF /datapath_tb/dpif/dmemREN
add wave -noupdate -expand -group DPIF /datapath_tb/dpif/dmemWEN
add wave -noupdate -expand -group DPIF /datapath_tb/dpif/flushed
add wave -noupdate -expand -group DPIF /datapath_tb/dpif/dmemload
add wave -noupdate -expand -group DPIF /datapath_tb/dpif/dmemstore
add wave -noupdate -expand -group DPIF /datapath_tb/dpif/dmemaddr
add wave -noupdate /datapath_tb/DUT/PC
add wave -noupdate /datapath_tb/DUT/PC_nxt
add wave -noupdate -expand -group {Control Unit} /datapath_tb/DUT/cuif/instr_op
add wave -noupdate -expand -group {Control Unit} /datapath_tb/DUT/cuif/funct_op
add wave -noupdate -expand -group {Control Unit} /datapath_tb/DUT/cuif/alu_op
add wave -noupdate -expand -group {Control Unit} /datapath_tb/DUT/cuif/RegDst
add wave -noupdate -expand -group {Control Unit} /datapath_tb/DUT/cuif/Branch
add wave -noupdate -expand -group {Control Unit} /datapath_tb/DUT/cuif/MemRead
add wave -noupdate -expand -group {Control Unit} /datapath_tb/DUT/cuif/MemWrite
add wave -noupdate -expand -group {Control Unit} /datapath_tb/DUT/cuif/RegWrite
add wave -noupdate -expand -group {Control Unit} /datapath_tb/DUT/cuif/JAL
add wave -noupdate -expand -group {Control Unit} /datapath_tb/DUT/cuif/ALUSRC
add wave -noupdate -expand -group {Control Unit} /datapath_tb/DUT/cuif/ExtType
add wave -noupdate -expand -group {Control Unit} /datapath_tb/DUT/cuif/Jump
add wave -noupdate -expand -group {Control Unit} /datapath_tb/DUT/cuif/MemToReg
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {180 ns} 0}
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
WaveRestoreZoom {0 ns} {319 ns}
