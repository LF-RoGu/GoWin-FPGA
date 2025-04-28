onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate /tb_top/clk
add wave -noupdate /tb_top/slow_clk
add wave -noupdate -divider clkDivider
add wave -noupdate /tb_top/clkDivider_top/DIVISOR
add wave -noupdate /tb_top/clkDivider_top/clk
add wave -noupdate /tb_top/clkDivider_top/rst
add wave -noupdate /tb_top/clkDivider_top/clk_out
add wave -noupdate -radix decimal /tb_top/clkDivider_top/counter
add wave -noupdate -divider bitShifter
add wave -noupdate /tb_top/bitShifter_top/clk
add wave -noupdate /tb_top/bitShifter_top/rst
add wave -noupdate /tb_top/bitShifter_top/out_bits
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {32155 ps} 0}
quietly wave cursor active 1
configure wave -namecolwidth 266
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
configure wave -timelineunits ps
update
WaveRestoreZoom {31295 ps} {33015 ps}
