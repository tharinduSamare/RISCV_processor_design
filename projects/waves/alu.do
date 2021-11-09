onerror {resume}
quietly WaveActivateNextPane {} 0
add wave -noupdate -expand -group main /alu_tb/clk
add wave -noupdate -expand -group main -radix decimal /alu_tb/read1
add wave -noupdate -expand -group main -radix decimal /alu_tb/read2
add wave -noupdate -expand -group main -radix decimal /alu_tb/write
add wave -noupdate -expand -group main /alu_tb/aluSrc2
add wave -noupdate -expand -group main /alu_tb/aluOp
add wave -noupdate -expand -group main /alu_tb/funct7
add wave -noupdate -expand -group main -radix unsigned /alu_tb/funct3
add wave -noupdate -expand -group main -radix decimal /alu_tb/out
add wave -noupdate -expand -group aluOp /alu_tb/op/aluOp
add wave -noupdate -expand -group aluOp /alu_tb/op/funct7
add wave -noupdate -expand -group aluOp /alu_tb/op/funct3
add wave -noupdate -expand -group aluOp /alu_tb/op/opSel
add wave -noupdate -expand -group aluOp /alu_tb/op/nextOpSel
add wave -noupdate -expand -group mux /alu_tb/mux/aluSrc2
add wave -noupdate -expand -group mux -radix decimal /alu_tb/mux/imm
add wave -noupdate -expand -group mux -radix decimal /alu_tb/mux/read2
add wave -noupdate -expand -group mux -radix decimal /alu_tb/mux/bus_b
add wave -noupdate -expand -group alu -radix decimal /alu_tb/alu/bus_a
add wave -noupdate -expand -group alu -radix decimal /alu_tb/alu/bus_b
add wave -noupdate -expand -group alu /alu_tb/alu/opSel
add wave -noupdate -expand -group alu -radix decimal /alu_tb/alu/out
add wave -noupdate -expand -group alu -radix decimal /alu_tb/alu/sub_res
TreeUpdate [SetDefaultTree]
WaveRestoreCursors {{Cursor 1} {184433 ps} 0}
quietly wave cursor active 1
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
configure wave -timelineunits ps
update
WaveRestoreZoom {60350 ps} {207350 ps}
