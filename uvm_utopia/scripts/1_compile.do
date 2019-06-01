vlib work
vmap work work
vlog -work work -sv ../src/uvm_tb3/seq_cell.sv 
vlog -work work -sv ../src/uvm_tb3/utopia.sv
vlog -work work -sv ../src/uvm_tb3/config.sv 
vlog -work work -sv ../src/uvm_tb3/definitions.sv
vlog -work work -sv ../src/uvm_tb3/sequence.sv 
vlog -work work -sv ../src/uvm_tb3/driver.sv 
vlog -work work -sv ../src/uvm_tb3/agent.sv 
vlog -work work -sv ../src/uvm_tb3/monitor.sv
vlog -work work -sv ../src/uvm_tb3/scoreboard.sv

vlog -work work -sv ../src/uvm_tb3/cpu_ifc.sv
vlog -work work -sv ../src/uvm_tb3/cpu_driver.sv
vlog -work work -sv ../src/uvm_tb3/env.sv 
vlog -work work -sv ../src/dut/utopia1_atm_rx.sv 
vlog -work work -sv ../src/dut/utopia1_atm_tx.sv  
vlog -work work -sv ../src/dut/squat.sv 
vlog -work work -sv ../src/uvm_tb3/test.sv
vlog -work work -sv ../src/dut/top.sv 
vlog -work work -sv ../src/uvm_tb3/LookupTable.sv


set NoQuitOnFinish 1

vsim +UVM_TESTNAME=test +UVM_VERBOSITY=low -novopt work.top
