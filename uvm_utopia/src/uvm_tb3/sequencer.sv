
`ifndef SEQUENCER__SV
`define SEQUENCER__SV
import uvm_pkg::*;
`include "uvm_macros.svh"

class utopia_sequencer extends uvm_sequencer#(UNI_cell);
	`uvm_sequencer_utils(utopia_sequencer)

	function new(string name, uvm_component parent);
		super.new(name,parent);
	endfunction : new

endclass
`endif