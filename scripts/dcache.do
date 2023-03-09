onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /dcache_tb/PROG/tb_test_case
add wave -noupdate /dcache_tb/CLK
add wave -noupdate /dcache_tb/nRST
add wave -noupdate -radix unsigned -childformat {{{/dcache_tb/DUT/dcache[7]} -radix unsigned -childformat {{frame -radix hexadecimal -childformat {{{[1]} -radix hexadecimal -childformat {{valid -radix hexadecimal} {tag -radix hexadecimal} {data -radix unsigned -childformat {{{[1]} -radix unsigned} {{[0]} -radix unsigned}}} {dirty -radix hexadecimal}}} {{[0]} -radix hexadecimal}}} {LRU -radix hexadecimal}}} {{/dcache_tb/DUT/dcache[6]} -radix unsigned} {{/dcache_tb/DUT/dcache[5]} -radix unsigned} {{/dcache_tb/DUT/dcache[4]} -radix unsigned} {{/dcache_tb/DUT/dcache[3]} -radix unsigned} {{/dcache_tb/DUT/dcache[2]} -radix unsigned} {{/dcache_tb/DUT/dcache[1]} -radix unsigned} {{/dcache_tb/DUT/dcache[0]} -radix unsigned}} -expand -subitemconfig {{/dcache_tb/DUT/dcache[7]} {-height 16 -radix unsigned -childformat {{frame -radix hexadecimal -childformat {{{[1]} -radix hexadecimal -childformat {{valid -radix hexadecimal} {tag -radix hexadecimal} {data -radix unsigned -childformat {{{[1]} -radix unsigned} {{[0]} -radix unsigned}}} {dirty -radix hexadecimal}}} {{[0]} -radix hexadecimal}}} {LRU -radix hexadecimal}}} {/dcache_tb/DUT/dcache[7].frame} {-radix hexadecimal -childformat {{{[1]} -radix hexadecimal -childformat {{valid -radix hexadecimal} {tag -radix hexadecimal} {data -radix unsigned -childformat {{{[1]} -radix unsigned} {{[0]} -radix unsigned}}} {dirty -radix hexadecimal}}} {{[0]} -radix hexadecimal}}} {/dcache_tb/DUT/dcache[7].frame[1]} {-radix hexadecimal -childformat {{valid -radix hexadecimal} {tag -radix hexadecimal} {data -radix unsigned -childformat {{{[1]} -radix unsigned} {{[0]} -radix unsigned}}} {dirty -radix hexadecimal}}} {/dcache_tb/DUT/dcache[7].frame[1].valid} {-radix hexadecimal} {/dcache_tb/DUT/dcache[7].frame[1].tag} {-radix hexadecimal} {/dcache_tb/DUT/dcache[7].frame[1].data} {-radix unsigned -childformat {{{[1]} -radix unsigned} {{[0]} -radix unsigned}}} {/dcache_tb/DUT/dcache[7].frame[1].data[1]} {-radix unsigned} {/dcache_tb/DUT/dcache[7].frame[1].data[0]} {-radix unsigned} {/dcache_tb/DUT/dcache[7].frame[1].dirty} {-radix hexadecimal} {/dcache_tb/DUT/dcache[7].frame[0]} {-radix hexadecimal} {/dcache_tb/DUT/dcache[7].LRU} {-radix hexadecimal} {/dcache_tb/DUT/dcache[6]} {-height 16 -radix unsigned} {/dcache_tb/DUT/dcache[5]} {-height 16 -radix unsigned} {/dcache_tb/DUT/dcache[4]} {-height 16 -radix unsigned} {/dcache_tb/DUT/dcache[3]} {-height 16 -radix unsigned} {/dcache_tb/DUT/dcache[2]} {-height 16 -radix unsigned} {/dcache_tb/DUT/dcache[1]} {-height 16 -radix unsigned} {/dcache_tb/DUT/dcache[0]} {-height 16 -radix unsigned}} /dcache_tb/DUT/dcache
add wave -noupdate /dcache_tb/DUT/datapath_tag
add wave -noupdate /dcache_tb/DUT/datapath_index
add wave -noupdate /dcache_tb/DUT/datapath_block_offset
add wave -noupdate /dcache_tb/DUT/miss
add wave -noupdate /dcache_tb/DUT/valid
add wave -noupdate /dcache_tb/DUT/dirty
add wave -noupdate /dcache_tb/DUT/cur_state
add wave -noupdate -expand -group CIF /dcache_tb/PROG/cif/iwait
add wave -noupdate -expand -group CIF /dcache_tb/PROG/cif/dwait
add wave -noupdate -expand -group CIF /dcache_tb/PROG/cif/iREN
add wave -noupdate -expand -group CIF /dcache_tb/PROG/cif/dREN
add wave -noupdate -expand -group CIF /dcache_tb/PROG/cif/dWEN
add wave -noupdate -expand -group CIF /dcache_tb/PROG/cif/iload
add wave -noupdate -expand -group CIF /dcache_tb/PROG/cif/dload
add wave -noupdate -expand -group CIF -radix unsigned /dcache_tb/PROG/cif/dstore
add wave -noupdate -expand -group CIF /dcache_tb/PROG/cif/iaddr
add wave -noupdate -expand -group CIF /dcache_tb/PROG/cif/daddr
add wave -noupdate -expand -group CIF /dcache_tb/PROG/cif/ccwait
add wave -noupdate -expand -group CIF /dcache_tb/PROG/cif/ccinv
add wave -noupdate -expand -group CIF /dcache_tb/PROG/cif/ccwrite
add wave -noupdate -expand -group CIF /dcache_tb/PROG/cif/cctrans
add wave -noupdate -expand -group CIF /dcache_tb/PROG/cif/ccsnoopaddr
add wave -noupdate -group DCIF /dcache_tb/PROG/dcif/halt
add wave -noupdate -group DCIF /dcache_tb/PROG/dcif/ihit
add wave -noupdate -group DCIF /dcache_tb/PROG/dcif/imemREN
add wave -noupdate -group DCIF /dcache_tb/PROG/dcif/imemload
add wave -noupdate -group DCIF /dcache_tb/PROG/dcif/imemaddr
add wave -noupdate -group DCIF /dcache_tb/PROG/dcif/dhit
add wave -noupdate -group DCIF /dcache_tb/PROG/dcif/datomic
add wave -noupdate -group DCIF /dcache_tb/PROG/dcif/dmemREN
add wave -noupdate -group DCIF /dcache_tb/PROG/dcif/dmemWEN
add wave -noupdate -group DCIF /dcache_tb/PROG/dcif/flushed
add wave -noupdate -group DCIF -radix unsigned /dcache_tb/PROG/dcif/dmemload
add wave -noupdate -group DCIF -radix unsigned /dcache_tb/PROG/dcif/dmemstore
add wave -noupdate -group DCIF -radix unsigned /dcache_tb/PROG/dcif/dmemaddr
add wave -noupdate /dcache_tb/DUT/hit_count
add wave -noupdate /dcache_tb/DUT/row
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {3558 ns} 0}
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
WaveRestoreZoom {3512 ns} {3698 ns}
