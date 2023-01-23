onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /register_file_tb/PROG/tb_test_case
add wave -noupdate /register_file_tb/PROG/tb_test_case_num
add wave -noupdate /register_file_tb/tb_CLK
add wave -noupdate /register_file_tb/nRST
add wave -noupdate /register_file_tb/DUT/rfif/WEN
add wave -noupdate /register_file_tb/DUT/rfif/wsel
add wave -noupdate /register_file_tb/DUT/rfif/rsel1
add wave -noupdate /register_file_tb/DUT/rfif/rsel2
add wave -noupdate -radix decimal /register_file_tb/DUT/rfif/wdat
add wave -noupdate -expand -group {Read Outputs} -radix decimal /register_file_tb/DUT/rfif/rdat1
add wave -noupdate -expand -group {Read Outputs} -color Orange /register_file_tb/PROG/check_outputs/expected_r1
add wave -noupdate -expand -group {Read Outputs} -radix decimal /register_file_tb/DUT/rfif/rdat2
add wave -noupdate -expand -group {Read Outputs} -color Orange /register_file_tb/PROG/check_outputs/expected_r2
add wave -noupdate /register_file_tb/PROG/tb_mismatch
add wave -noupdate /register_file_tb/PROG/tb_check
add wave -noupdate -radix unsigned /register_file_tb/DUT/Primary_Data
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {1025000 ps} 0}
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
WaveRestoreZoom {966200 ps} {1166200 ps}
