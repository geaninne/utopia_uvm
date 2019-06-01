# utopia_uvm


This project is a testbench uvm adapted from the one in the book "SystemVerilog for Verification: A Guide to Learning the Testbench Language Features", by CHRIS SPEAR (Springer, 2012). 

To run in the questa tool should be entering the scripts directory and executing the following command:
 
 "do 3_simul.do"

Classes:

*seq_cell*: contains the specification of the UNI_cell, cells to be transmitted, and the NNI_cell, cells that are the output of the DUT;

*sequence*: creates and assigns random values to the cells and connects to the sequencer, which connects to the driver;

*driver*: directs the cells to the DUT and to the scoreboard;

*monitor*: receives the NNI_cell cells from the DUT and sends it to the scoreboard;

*agent*: creates the instances of the driver, monitor and sequencer;

*env*: creates instances of 4 agents;

*scoreboard*: check if the cells coming from the driver and monitor are the same (STILL NOT WORKING).
