onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memory_control_tb/PROG/tb_test_case
add wave -noupdate /memory_control_tb/CLK
add wave -noupdate /memory_control_tb/nRST
add wave -noupdate -expand -group {Ram Side} /memory_control_tb/DUT1/ccif/ramWEN
add wave -noupdate -expand -group {Ram Side} /memory_control_tb/DUT1/ccif/ramREN
add wave -noupdate -expand -group {Ram Side} /memory_control_tb/DUT1/ccif/ramstate
add wave -noupdate -expand -group {Ram Side} /memory_control_tb/DUT1/ccif/ramaddr
add wave -noupdate -expand -group {Ram Side} /memory_control_tb/DUT1/ccif/ramstore
add wave -noupdate -expand -group {Ram Side} /memory_control_tb/DUT1/ccif/ramload
add wave -noupdate -expand -group {Better Cache Side} /memory_control_tb/ccif/cif0/iwait
add wave -noupdate -expand -group {Better Cache Side} /memory_control_tb/ccif/cif0/dwait
add wave -noupdate -expand -group {Better Cache Side} /memory_control_tb/ccif/cif0/iREN
add wave -noupdate -expand -group {Better Cache Side} /memory_control_tb/ccif/cif0/dREN
add wave -noupdate -expand -group {Better Cache Side} /memory_control_tb/ccif/cif0/dWEN
add wave -noupdate -expand -group {Better Cache Side} /memory_control_tb/ccif/cif0/iload
add wave -noupdate -expand -group {Better Cache Side} /memory_control_tb/ccif/cif0/dload
add wave -noupdate -expand -group {Better Cache Side} /memory_control_tb/ccif/cif0/dstore
add wave -noupdate -expand -group {Better Cache Side} /memory_control_tb/ccif/cif0/iaddr
add wave -noupdate -expand -group {Better Cache Side} /memory_control_tb/ccif/cif0/daddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {645642 ps} 0}
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
WaveRestoreZoom {3031150 ps} {5214150 ps}
