import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../src/uvm_tb3/seq_cell.sv"  // include external definitions


class utopia_sequence extends uvm_sequence#(UNI_cell);
	`uvm_object_utils(utopia_sequence)	
	utopia_sequencer sequences[`RxPorts];

	/*Construtor*/
	function new (string name = "utopia_sequence");
		super.new(name);
	endfunction : new


	 task body();
		repeat(2)
		begin
			`uvm_do(req);
		end
	endtask : body
endclass 