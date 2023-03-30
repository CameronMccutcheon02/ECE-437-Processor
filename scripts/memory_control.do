onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /memory_control_tb/PROG/test_num
add wave -noupdate /memory_control_tb/PROG/test_case
add wave -noupdate /memory_control_tb/CLK
add wave -noupdate /memory_control_tb/PROG/check
add wave -noupdate /memory_control_tb/MEM/mc_state
add wave -noupdate -radix binary /memory_control_tb/PROG/ccif/iwait
add wave -noupdate -radix binary /memory_control_tb/PROG/ccif/dwait
add wave -noupdate -radix binary /memory_control_tb/PROG/ccif/iREN
add wave -noupdate -radix binary /memory_control_tb/PROG/ccif/dREN
add wave -noupdate -radix binary /memory_control_tb/PROG/ccif/dWEN
add wave -noupdate -radix unsigned -childformat {{{/memory_control_tb/PROG/ccif/iload[1]} -radix unsigned} {{/memory_control_tb/PROG/ccif/iload[0]} -radix unsigned}} -expand -subitemconfig {{/memory_control_tb/PROG/ccif/iload[1]} {-height 16 -radix unsigned} {/memory_control_tb/PROG/ccif/iload[0]} {-height 16 -radix unsigned}} /memory_control_tb/PROG/ccif/iload
add wave -noupdate -radix unsigned -childformat {{{/memory_control_tb/PROG/ccif/dload[1]} -radix unsigned} {{/memory_control_tb/PROG/ccif/dload[0]} -radix unsigned}} -expand -subitemconfig {{/memory_control_tb/PROG/ccif/dload[1]} {-height 16 -radix unsigned} {/memory_control_tb/PROG/ccif/dload[0]} {-height 16 -radix unsigned}} /memory_control_tb/PROG/ccif/dload
add wave -noupdate -radix unsigned -childformat {{{/memory_control_tb/PROG/ccif/dstore[1]} -radix unsigned} {{/memory_control_tb/PROG/ccif/dstore[0]} -radix unsigned}} -expand -subitemconfig {{/memory_control_tb/PROG/ccif/dstore[1]} {-height 16 -radix unsigned} {/memory_control_tb/PROG/ccif/dstore[0]} {-height 16 -radix unsigned}} /memory_control_tb/PROG/ccif/dstore
add wave -noupdate -radix unsigned -childformat {{{/memory_control_tb/PROG/ccif/iaddr[1]} -radix unsigned} {{/memory_control_tb/PROG/ccif/iaddr[0]} -radix unsigned}} -expand -subitemconfig {{/memory_control_tb/PROG/ccif/iaddr[1]} {-height 16 -radix unsigned} {/memory_control_tb/PROG/ccif/iaddr[0]} {-height 16 -radix unsigned}} /memory_control_tb/PROG/ccif/iaddr
add wave -noupdate -radix unsigned -childformat {{{/memory_control_tb/PROG/ccif/daddr[1]} -radix unsigned} {{/memory_control_tb/PROG/ccif/daddr[0]} -radix unsigned}} -expand -subitemconfig {{/memory_control_tb/PROG/ccif/daddr[1]} {-height 16 -radix unsigned} {/memory_control_tb/PROG/ccif/daddr[0]} {-height 16 -radix unsigned}} /memory_control_tb/PROG/ccif/daddr
add wave -noupdate -group coherence -expand /memory_control_tb/PROG/ccif/ccwait
add wave -noupdate -group coherence -expand /memory_control_tb/PROG/ccif/ccinv
add wave -noupdate -group coherence -expand /memory_control_tb/PROG/ccif/ccwrite
add wave -noupdate -group coherence -expand /memory_control_tb/PROG/ccif/cctrans
add wave -noupdate -group coherence -expand /memory_control_tb/PROG/ccif/ccsnoopaddr
add wave -noupdate -expand -group RamSignals /memory_control_tb/PROG/ccif/ramWEN
add wave -noupdate -expand -group RamSignals /memory_control_tb/PROG/ccif/ramREN
add wave -noupdate -expand -group RamSignals /memory_control_tb/PROG/ccif/ramstate
add wave -noupdate -expand -group RamSignals /memory_control_tb/PROG/ccif/ramaddr
add wave -noupdate -expand -group RamSignals /memory_control_tb/PROG/ccif/ramstore
add wave -noupdate -expand -group RamSignals /memory_control_tb/PROG/ccif/ramload
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {178838 ps} 0}
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
WaveRestoreZoom {164098 ps} {296098 ps}
