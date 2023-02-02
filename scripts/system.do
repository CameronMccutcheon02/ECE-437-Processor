onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate -expand -group {System Interface} /system_tb/PROG/syif/tbCTRL
add wave -noupdate -expand -group {System Interface} /system_tb/PROG/syif/halt
add wave -noupdate -expand -group {System Interface} /system_tb/PROG/syif/WEN
add wave -noupdate -expand -group {System Interface} /system_tb/PROG/syif/REN
add wave -noupdate -expand -group {System Interface} /system_tb/PROG/syif/addr
add wave -noupdate -expand -group {System Interface} /system_tb/PROG/syif/store
add wave -noupdate -expand -group {System Interface} /system_tb/PROG/syif/load
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/imemREN
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/datomic
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/flushed
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate -group dpif /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate -expand -group cuif /system_tb/DUT/CPU/DP/cuif/instr_op
add wave -noupdate -expand -group cuif /system_tb/DUT/CPU/DP/cuif/funct_op
add wave -noupdate -expand -group cuif /system_tb/DUT/CPU/DP/cuif/alu_op
add wave -noupdate -expand -group cuif /system_tb/DUT/CPU/DP/cuif/RegDst
add wave -noupdate -expand -group cuif /system_tb/DUT/CPU/DP/cuif/Branch
add wave -noupdate -expand -group cuif /system_tb/DUT/CPU/DP/cuif/MemRead
add wave -noupdate -expand -group cuif /system_tb/DUT/CPU/DP/cuif/MemWrite
add wave -noupdate -expand -group cuif /system_tb/DUT/CPU/DP/cuif/RegWrite
add wave -noupdate -expand -group cuif /system_tb/DUT/CPU/DP/cuif/JAL
add wave -noupdate -expand -group cuif /system_tb/DUT/CPU/DP/cuif/ALUSRC
add wave -noupdate -expand -group cuif /system_tb/DUT/CPU/DP/cuif/ExtType
add wave -noupdate -expand -group cuif /system_tb/DUT/CPU/DP/cuif/Jump
add wave -noupdate -expand -group cuif /system_tb/DUT/CPU/DP/cuif/MemToReg
add wave -noupdate -expand -group rfif /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate -expand -group rfif /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -expand -group rfif /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -expand -group rfif /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate -expand -group rfif /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate -expand -group rfif /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate -expand -group rfif /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -group aluif /system_tb/DUT/CPU/DP/aluif/alu_op
add wave -noupdate -group aluif /system_tb/DUT/CPU/DP/aluif/neg
add wave -noupdate -group aluif /system_tb/DUT/CPU/DP/aluif/zero
add wave -noupdate -group aluif /system_tb/DUT/CPU/DP/aluif/over
add wave -noupdate -group aluif /system_tb/DUT/CPU/DP/aluif/port_a
add wave -noupdate -group aluif /system_tb/DUT/CPU/DP/aluif/port_b
add wave -noupdate -group aluif /system_tb/DUT/CPU/DP/aluif/port_o
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/MemRead
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/MemWrite
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/stall
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/instr_op
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/funct_op
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/halt
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/ihit
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/imemREN
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/imemload
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/imemaddr
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/pc
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/imem
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/dhit
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/datomic
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/dmemREN
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/dmemWEN
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/flushed
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/dmemload
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/dmemstore
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/dmemaddr
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/port_o
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/port_b
add wave -noupdate -expand -group ruif /system_tb/DUT/CPU/DP/ruif/dmem
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/iwait
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/dwait
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/iREN
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/dREN
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/dWEN
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/iload
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/dload
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/dstore
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/iaddr
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/daddr
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/ccwait
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/ccinv
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/ccwrite
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/cctrans
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/ccsnoopaddr
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/ramWEN
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/ramREN
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/ramstate
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/ramaddr
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/ramstore
add wave -noupdate -group MemCont /system_tb/DUT/CPU/CC/ccif/ramload
add wave -noupdate /system_tb/DUT/CPU/DP/RF/Primary_Data
add wave -noupdate /system_tb/DUT/CPU/DP/PC
add wave -noupdate /system_tb/DUT/CPU/DP/PC_nxt
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28774 ps} 0}
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
WaveRestoreZoom {0 ps} {425 ns}
