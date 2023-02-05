onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/CLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/DP/Instruction
add wave -noupdate /system_tb/DUT/CPU/DP/op
add wave -noupdate /system_tb/DUT/CPU/DP/rs
add wave -noupdate /system_tb/DUT/CPU/DP/rt
add wave -noupdate /system_tb/DUT/CPU/DP/rd
add wave -noupdate /system_tb/DUT/CPU/DP/imm
add wave -noupdate /system_tb/DUT/CPU/DP/func
add wave -noupdate /system_tb/DUT/CPU/DP/npc
add wave -noupdate /system_tb/DUT/CPU/DP/ZeroExtImm
add wave -noupdate /system_tb/DUT/CPU/DP/SignExtImm
add wave -noupdate /system_tb/DUT/CPU/DP/JumpAddr
add wave -noupdate /system_tb/DUT/CPU/DP/JRAddr
add wave -noupdate /system_tb/DUT/CPU/DP/BranchAddr
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/halt
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/ihit
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/imemREN
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/imemload
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/imemaddr
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/dhit
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/datomic
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/dmemREN
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/dmemWEN
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/flushed
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/dmemload
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/dmemstore
add wave -noupdate -group Datapath /system_tb/DUT/CPU/DP/dpif/dmemaddr
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/aluif/ALUOP
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/aluif/porta
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/aluif/portb
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/aluif/oport
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/aluif/negative
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/aluif/zero
add wave -noupdate -group ALU /system_tb/DUT/CPU/DP/aluif/overflow
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/opcode
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/func
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/ALUctr
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/ihit
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/dhit
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/zero
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/jal
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/RegDst
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/RegWr
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/ALUSrc
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/BEQ
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/BNE
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/ExtOP
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/halt
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/iREN
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/dREN
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/dWEN
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/MemtoReg
add wave -noupdate -group {Control Unit} /system_tb/DUT/CPU/DP/cuif/JumpSel
add wave -noupdate -group {Register File} /system_tb/DUT/CPU/DP/rfif/WEN
add wave -noupdate -group {Register File} /system_tb/DUT/CPU/DP/rfif/wsel
add wave -noupdate -group {Register File} /system_tb/DUT/CPU/DP/rfif/rsel1
add wave -noupdate -group {Register File} /system_tb/DUT/CPU/DP/rfif/rsel2
add wave -noupdate -group {Register File} /system_tb/DUT/CPU/DP/rfif/wdat
add wave -noupdate -group {Register File} /system_tb/DUT/CPU/DP/rfif/rdat1
add wave -noupdate -group {Register File} /system_tb/DUT/CPU/DP/rfif/rdat2
add wave -noupdate -group {Register File} /system_tb/DUT/CPU/DP/RF/registers
add wave -noupdate -group {Request Unit} /system_tb/DUT/CPU/DP/ruif/iREN
add wave -noupdate -group {Request Unit} /system_tb/DUT/CPU/DP/ruif/dREN
add wave -noupdate -group {Request Unit} /system_tb/DUT/CPU/DP/ruif/dWEN
add wave -noupdate -group {Request Unit} /system_tb/DUT/CPU/DP/ruif/ihit
add wave -noupdate -group {Request Unit} /system_tb/DUT/CPU/DP/ruif/dhit
add wave -noupdate -group {Request Unit} /system_tb/DUT/CPU/DP/ruif/imemREN
add wave -noupdate -group {Request Unit} /system_tb/DUT/CPU/DP/ruif/dmemREN
add wave -noupdate -group {Request Unit} /system_tb/DUT/CPU/DP/ruif/dmemWEN
add wave -noupdate -group {Program Counter} /system_tb/DUT/CPU/DP/pcif/PC
add wave -noupdate -group {Program Counter} /system_tb/DUT/CPU/DP/pcif/next_PC
add wave -noupdate -group {Program Counter} /system_tb/DUT/CPU/DP/pcif/EN
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
WaveRestoreZoom {0 ps} {1819 ns}
