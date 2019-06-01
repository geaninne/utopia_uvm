onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate {/top/squat/Rx[0]/data}
add wave -noupdate {/top/squat/Rx[0]/clk_in}
add wave -noupdate {/top/squat/Rx[0]/clk_out}
add wave -noupdate {/top/squat/Rx[0]/soc}
add wave -noupdate {/top/squat/Rx[0]/en}
add wave -noupdate {/top/squat/Rx[0]/clav}
add wave -noupdate {/top/squat/Rx[0]/valid}
add wave -noupdate {/top/squat/Rx[0]/ready}
add wave -noupdate {/top/squat/Rx[0]/reset}
add wave -noupdate {/top/squat/Rx[0]/selected}
add wave -noupdate {/top/squat/Rx[0]/ATMcell}
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {28 ns} 0}
configure wave -namecolwidth 150
configure wave -valuecolwidth 100
configure wave -justifyvalue left
configure wave -signalnamewidth 0
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
WaveRestoreZoom {0 ns} {84 ns}
