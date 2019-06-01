import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../src/uvm_tb3/seq_cell.sv"  // include external definitions
`include "../src/uvm_tb3/definitions.sv"  // include external definitions
`include "../src/uvm_tb3/utopia.sv"  // include external definitions

class driver extends uvm_driver #(UNI_cell);
  `uvm_component_utils(driver)

    uvm_analysis_port#(UNI_cell) fromDriver;
  virtual Utopia.TB_Rx uif;
  int portn;
  /*Construtor*/
  function new (string name = "driver", uvm_component parent);
    super.new(name, parent);
  endfunction : new
 

  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    if (!uvm_config_db #(virtual Utopia.TB_Rx)::get (this, "", "uif", uif) )
    begin
      uvm_config_db #(int)::dump(); 
      `uvm_fatal("dr", "No top_receive_if");
    end
  fromDriver = new("fromDriver", this); 

  if (!uvm_config_db #(int)::get (this,"", "portn", portn) )
  begin
    uvm_config_db #(int)::dump(); 
    `uvm_fatal("driver", "No portn configuration");
  end

  endfunction: build_phase

  // run phase
  virtual task run_phase(uvm_phase phase);
    UNI_cell c;
    forever begin
      $display("AGUARDANDO SEQUENCER");
      seq_item_port.get_next_item(c);
      $display("ITEM RECEBIDO");

      send(c);
      $display("ITEM ENVIADO");
      fromDriver.write(c);

       seq_item_port.item_done();
    end
  endtask : run_phase
 
  task send(input UNI_cell c);
   ATMCellType Pkt;

   c.pack(Pkt);
   $write("Sending cell: "); foreach (Pkt.Mem[i]) $write("%x ", Pkt.Mem[i]); $display;
   @(uif.cbr);
   uif.cbr.clav <= 1;
   for (int i=0; i<=52; i++) begin
      while (uif.cbr.en === 1'b1) @(uif.cbr);

      uif.cbr.soc  <= (i == 0);
      uif.cbr.data <= Pkt.Mem[i];
      @(uif.cbr);
    end
   uif.cbr.soc <= 'z;
   uif.cbr.data <= 8'bx;
   uif.cbr.clav <= 0;
endtask

endclass : driver