onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /system_tb/DUT/CPUCLK
add wave -noupdate /system_tb/nRST
add wave -noupdate /system_tb/DUT/CPU/halt
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramREN
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramWEN
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramaddr
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramstore
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramload
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/ramstate
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/memREN
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/memWEN
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/memaddr
add wave -noupdate -group scif /system_tb/DUT/CPU/scif/memstore
add wave -noupdate -divider CPU0
add wave -noupdate -radix hexadecimal /system_tb/DUT/CPU/DP0/DC/Instruction
add wave -noupdate /system_tb/DUT/CPU/DP0/DC/op
add wave -noupdate /system_tb/DUT/CPU/DP0/DC/func
add wave -noupdate /system_tb/DUT/CPU/CM0/DCACHE/nxt_lr
add wave -noupdate -expand /system_tb/DUT/CPU/CM0/DCACHE/lr
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/cur_state
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/nxt_state
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/prev_state
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/dcache
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/nxt_dcache
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/addr
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/snoopaddr
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/datapath_tag
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/datapath_index
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/datapath_block_offset
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/datapath_byte_offset
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/row
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/nxt_row
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/hit_count
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/nxt_hit_count
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/miss
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/valid
add wave -noupdate -expand -group DCACHE0 /system_tb/DUT/CPU/CM0/DCACHE/dirty
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/halt
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/ihit
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/imemREN
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/imemload
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/imemaddr
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dhit
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/datomic
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dmemREN
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dmemWEN
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/flushed
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dmemload
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dmemstore
add wave -noupdate -expand -group dcif0 /system_tb/DUT/CPU/dcif0/dmemaddr
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
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/ihit
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/dhit
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/flush
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/freeze
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/execute_p
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/dmemload
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/memory_p
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/dmemaddr
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/dmemstore
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/dmemREN
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/dmemWEN
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/BranchAddr
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/JumpAddr
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/port_a
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/JumpSel
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/BranchTaken
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/branch_mispredict
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/PC
add wave -noupdate -group memstage0 /system_tb/DUT/CPU/DP0/MM/mmif/forwarding_unit_data
add wave -noupdate -divider CPU1
add wave -noupdate /system_tb/DUT/CPU/DP1/DC/Instruction
add wave -noupdate /system_tb/DUT/CPU/DP1/DC/op
add wave -noupdate /system_tb/DUT/CPU/DP1/DC/func
add wave -noupdate -expand /system_tb/DUT/CPU/CM1/DCACHE/lr
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
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/ihit
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/dhit
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/flush
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/freeze
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/execute_p
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/dmemload
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/memory_p
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/dmemaddr
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/dmemstore
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/dmemREN
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/dmemWEN
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/BranchAddr
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/JumpAddr
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/port_a
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/JumpSel
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/BranchTaken
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/branch_mispredict
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/PC
add wave -noupdate -group memstage1 /system_tb/DUT/CPU/DP1/MM/mmif/forwarding_unit_data
add wave -noupdate -divider BUS
add wave -noupdate /system_tb/DUT/CPU/CC/mc_state
add wave -noupdate /system_tb/DUT/CPU/CC/next_mc_state
add wave -noupdate /system_tb/DUT/CPU/CC/mc
add wave -noupdate /system_tb/DUT/CPU/CC/next_mc
add wave -noupdate -group Bus /system_tb/DUT/CPU/ccif/iwait
add wave -noupdate -group Bus /system_tb/DUT/CPU/ccif/dwait
add wave -noupdate -group Bus /system_tb/DUT/CPU/ccif/iREN
add wave -noupdate -group Bus /system_tb/DUT/CPU/ccif/dREN
add wave -noupdate -group Bus /system_tb/DUT/CPU/ccif/dWEN
add wave -noupdate -group Bus /system_tb/DUT/CPU/ccif/iload
add wave -noupdate -group Bus /system_tb/DUT/CPU/ccif/dload
add wave -noupdate -group Bus /system_tb/DUT/CPU/ccif/dstore
add wave -noupdate -group Bus /system_tb/DUT/CPU/ccif/iaddr
add wave -noupdate -group Bus /system_tb/DUT/CPU/ccif/daddr
add wave -noupdate -group Bus -expand -group Coherence /system_tb/DUT/CPU/ccif/ccwait
add wave -noupdate -group Bus -expand -group Coherence /system_tb/DUT/CPU/ccif/ccinv
add wave -noupdate -group Bus -expand -group Coherence /system_tb/DUT/CPU/ccif/ccwrite
add wave -noupdate -group Bus -expand -group Coherence /system_tb/DUT/CPU/ccif/cctrans
add wave -noupdate -group Bus -expand -group Coherence /system_tb/DUT/CPU/ccif/ccsnoopaddr
add wave -noupdate -group Bus /system_tb/DUT/CPU/ccif/ramWEN
add wave -noupdate -group Bus /system_tb/DUT/CPU/ccif/ramREN
add wave -noupdate -group Bus /system_tb/DUT/CPU/ccif/ramstate
add wave -noupdate -group Bus /system_tb/DUT/CPU/ccif/ramaddr
add wave -noupdate -group Bus /system_tb/DUT/CPU/ccif/ramstore
add wave -noupdate -group Bus /system_tb/DUT/CPU/ccif/ramload
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {51799904 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 191
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
WaveRestoreZoom {45344800 ps} {58785800 ps}
