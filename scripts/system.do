onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/halt
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/ramREN
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/ramWEN
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/ramaddr
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/ramstore
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/ramload
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/ramstate
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/memREN
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/memWEN
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/memaddr
add wave -noupdate -expand -group scif /system_tb/DUT/CPU/scif/memstore
add wave -noupdate -divider CPU0
add wave -noupdate -radix symbolic /system_tb/DUT/CPU/DP0/DC/Instruction
add wave -noupdate /system_tb/DUT/CPU/DP0/DC/op
add wave -noupdate /system_tb/DUT/CPU/DP0/DC/func
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/cur_state
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/nxt_state
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/prev_state
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/dcache
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/nxt_dcache
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/addr
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/snoopaddr
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/datapath_tag
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/datapath_index
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/datapath_block_offset
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/datapath_byte_offset
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/row
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/nxt_row
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/hit_count
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/nxt_hit_count
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/miss
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/valid
add wave -noupdate -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/dirty
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/halt
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/ihit
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/imemREN
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/imemload
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/imemaddr
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dhit
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/datomic
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemREN
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemWEN
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/flushed
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemload
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemstore
add wave -noupdate -group dcif0 /system_tb/DUT/CPU/dcif0/dmemaddr
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/iwait
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dwait
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/iREN
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dREN
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dWEN
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/iload
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dload
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/dstore
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/iaddr
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/daddr
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/ccwait
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/ccinv
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/ccwrite
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/cctrans
add wave -noupdate -group cif0 /system_tb/DUT/CPU/cif0/ccsnoopaddr
add wave -noupdate -divider CPU1
add wave -noupdate /system_tb/DUT/CPU/DP1/DC/Instruction
add wave -noupdate /system_tb/DUT/CPU/DP1/DC/op
add wave -noupdate /system_tb/DUT/CPU/DP1/DC/func
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/halt
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/ihit
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemREN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemload
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/imemaddr
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dhit
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/datomic
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemREN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemWEN
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/flushed
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemload
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemstore
add wave -noupdate -group dcif1 /system_tb/DUT/CPU/dcif1/dmemaddr
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iwait
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dwait
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iREN
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dREN
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dWEN
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iload
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dload
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/dstore
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/iaddr
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/daddr
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccwait
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccinv
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccwrite
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/cctrans
add wave -noupdate -group cif1 /system_tb/DUT/CPU/cif1/ccsnoopaddr
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/cur_state
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/nxt_state
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/prev_state
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/dcache
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/nxt_dcache
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/addr
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/snoopaddr
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/datapath_tag
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/datapath_index
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/datapath_block_offset
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/datapath_byte_offset
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/row
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/nxt_row
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/hit_count
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/nxt_hit_count
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/miss
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/valid
add wave -noupdate -group DCACHE1 /system_tb/DUT/CPU/CM1/DCACHE/dirty
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
WaveRestoreZoom {0 ps} {2601385 ps}
