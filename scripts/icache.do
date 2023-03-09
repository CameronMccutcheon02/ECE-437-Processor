onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /icache_tb/CLK
add wave -noupdate /icache_tb/nRST
add wave -noupdate /icache_tb/DUT/icache
add wave -noupdate /icache_tb/DUT/tag
add wave -noupdate /icache_tb/DUT/index
add wave -noupdate -expand -group dcif /icache_tb/dcif/halt
add wave -noupdate -expand -group dcif /icache_tb/dcif/ihit
add wave -noupdate -expand -group dcif /icache_tb/dcif/imemREN
add wave -noupdate -expand -group dcif /icache_tb/dcif/imemload
add wave -noupdate -expand -group dcif /icache_tb/dcif/imemaddr
add wave -noupdate -expand -group dcif /icache_tb/dcif/dmemREN
add wave -noupdate -expand -group dcif /icache_tb/dcif/dmemWEN
add wave -noupdate -expand -group cif /icache_tb/cif/iwait
add wave -noupdate -expand -group cif /icache_tb/cif/iREN
add wave -noupdate -expand -group cif /icache_tb/cif/dREN
add wave -noupdate -expand -group cif /icache_tb/cif/dWEN
add wave -noupdate -expand -group cif /icache_tb/cif/iload
add wave -noupdate -expand -group cif /icache_tb/cif/iaddr
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {0 ps} 0}
quietly wave cursor active 0
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
WaveRestoreZoom {0 ps} {1206640 ps}
