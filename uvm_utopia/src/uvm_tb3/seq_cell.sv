`ifndef SEQ_CELL__SV
`define SEQ_CELL__SV

import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../src/uvm_tb3/definitions.sv"  // include external definitions


virtual class BaseTr extends uvm_sequence_item;

	/*Número de instancias criadas*/
	static int count;  
	int id;            

  /*Construtor*/
	function new(string name = "BaseTr");		
		super.new(name);
		id = count++;
	endfunction : new

endclass : BaseTr
typedef class NNI_cell;



class UNI_cell extends BaseTr;

   // Physical fields
	rand bit        [3:0]  GFC;
	rand bit        [7:0]  VPI;
	rand bit        [15:0] VCI;
	rand bit               CLP;
	rand bit        [2:0]  PT;
    	 bit        [7:0]  HEC;
	rand bit [0:47] [7:0]  Payload;

   // Meta-data fields
   static bit [7:0] syndrome[0:255];
   static bit syndrome_not_generated = 1;

   //UVM_ALL_ON permite que todas as operações (copy, compare, etc) sejam realizadas para esses valores.
   `uvm_object_utils_begin(UNI_cell)
      `uvm_field_int(GFC, UVM_ALL_ON)
      `uvm_field_int(VPI, UVM_ALL_ON)
      `uvm_field_int(VCI, UVM_ALL_ON)
      `uvm_field_int(CLP, UVM_ALL_ON)
      `uvm_field_int(PT, UVM_ALL_ON)
      `uvm_field_int(HEC, UVM_ALL_ON)
      `uvm_field_int(Payload,UVM_ALL_ON)
   `uvm_object_utils_end

   	/*Construtor*/
    function new(string name = "UNI_cell");
    	super.new("UNI_cell");
    	if (syndrome_not_generated)
     		generate_syndrome();
   endfunction : new

   
  function void display(input string prefix);
    ATMCellType p;

    $display("%sUNI id:%0d GFC=%x, VPI=%x, VCI=%x, CLP=%b, PT=%x, HEC=%x, Payload[0]=%x",
    prefix, id, GFC, VPI, VCI, CLP, PT, HEC, Payload[0]);
    this.pack(p);
    $write("%s", prefix);
    foreach (p.Mem[i]) $write("%x ", p.Mem[i]); $display;
  endfunction : display


   /*gera valores q serão usados para criar o campo HEC*/
	function generate_syndrome();
		bit [7:0] sndrm;
		for (int i = 0; i < 256; i = i + 1 ) begin
    		sndrm = i;
      		repeat (8) begin
       		  	if (sndrm[7] === 1'b1)
           			sndrm = (sndrm << 1) ^ 8'h07;
         		else
           			sndrm = sndrm << 1;
    			end		
      			syndrome[i] = sndrm;
   		end
   		syndrome_not_generated = 0;

	endfunction : generate_syndrome

	/*gera o valor HEC*/
	function bit [7:0] hec (bit [31:0] hdr);
		hec = 8'h00;
		repeat (4) begin
			hec = syndrome[hec ^ hdr[31:24]];
			hdr = hdr << 8;
   		end  
   		hec = hec ^ 8'h55;
	endfunction : hec

	/*Chama a funcao hec apos todos os valores serem gerados*/
	function void post_randomize();  	
   		HEC = hec({GFC, VPI, VCI, CLP, PT});
	endfunction : post_randomize

  function void pack(output ATMCellType to);
   to.uni.GFC     = this.GFC;
   to.uni.VPI     = this.VPI;
   to.uni.VCI     = this.VCI;
   to.uni.CLP     = this.CLP;
   to.uni.PT      = this.PT;
   to.uni.HEC     = this.HEC;
   to.uni.Payload = this.Payload;
endfunction : pack

// Generate a NNI cell from an UNI cell - used in scoreboard
function NNI_cell to_NNI();
   NNI_cell copy;
   copy = new();
   copy.VPI     = this.VPI;   // NNI has wider VPI
   copy.VCI     = this.VCI;
   copy.CLP     = this.CLP;
   copy.PT      = this.PT;
   copy.HEC     = this.HEC;
   copy.Payload = this.Payload;
   return copy;
endfunction : to_NNI

endclass : UNI_cell


typedef uvm_sequencer #(UNI_cell) utopia_sequencer;


class NNI_cell extends BaseTr;
   // Physical fields
   rand bit        [11:0] VPI;
   rand bit        [15:0] VCI;
   rand bit               CLP;
   rand bit        [2:0]  PT;
        bit        [7:0]  HEC;
   rand bit [0:47] [7:0]  Payload;
   int portID;
   // Meta-data fields
   static bit [7:0] syndrome[0:255];
   static bit syndrome_not_generated = 1;


   //UVM_ALL_ON permite que todas as operações (copy, compare, etc) sejam realizadas para esses valores.
   `uvm_object_utils_begin(NNI_cell)
      `uvm_field_int(VPI, UVM_ALL_ON)
      `uvm_field_int(VCI, UVM_ALL_ON)
      `uvm_field_int(CLP, UVM_ALL_ON)
      `uvm_field_int(PT, UVM_ALL_ON)
      `uvm_field_int(HEC, UVM_ALL_ON)
      `uvm_field_int(Payload,UVM_ALL_ON)
   `uvm_object_utils_end



   function new(string name = "NNI_cell");
      super.new("NNI_cell");
      if (syndrome_not_generated)
        generate_syndrome();
   endfunction : new 

function void pack(output ATMCellType to);
   to.nni.VPI     = this.VPI;
   to.nni.VCI     = this.VCI;
   to.nni.CLP     = this.CLP;
   to.nni.PT      = this.PT;
   to.nni.HEC     = this.HEC;
   to.nni.Payload = this.Payload;
endfunction : pack

function void display(input string prefix = "");
   ATMCellType p;

   $display("%sNNI id:%0d VPI=%x, VCI=%x, CLP=%b, PT=%x, HEC=%x, Payload[0]=%x",
      prefix, id, VPI, VCI, CLP, PT, HEC, Payload[0]);
   this.pack(p);
   $write("%s", prefix);
   foreach (p.Mem[i]) $write("%x ", p.Mem[i]); $display;
   //$write("%sUNI Payload=%x %x %x %x %x %x ...",
   $display;
endfunction : display



   function void post_randomize();
       HEC = hec({VPI, VCI, CLP, PT});
    endfunction : post_randomize

    function void generate_syndrome();
   bit [7:0] sndrm;
   for (int i = 0; i < 256; i = i + 1 ) begin
      sndrm = i;
      repeat (8) begin
         if (sndrm[7] === 1'b1)
           sndrm = (sndrm << 1) ^ 8'h07;
         else
           sndrm = sndrm << 1;
      end
      syndrome[i] = sndrm;
   end
   syndrome_not_generated = 0;
endfunction : generate_syndrome

function bit [7:0] hec (bit [31:0] hdr);
   hec = 8'h00;
   repeat (4) begin
      hec = syndrome[hec ^ hdr[31:24]];
      hdr = hdr << 8;
   end
   hec = hec ^ 8'h55;
endfunction : hec

function void unpack(input ATMCellType from);
   this.VPI     = from.nni.VPI;
   this.VCI     = from.nni.VCI;
   this.CLP     = from.nni.CLP;
   this.PT      = from.nni.PT;
   this.HEC     = from.nni.HEC;
   this.Payload = from.nni.Payload;
endfunction : unpack

  
endclass : NNI_cell



`endif 
