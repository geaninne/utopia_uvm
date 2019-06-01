import uvm_pkg::*;
`include "uvm_macros.svh"

`include "../src/uvm_tb3/seq_cell.sv"

/////////////////////////////////////////////////////////////////////////////
class monitor extends uvm_monitor;
    `uvm_component_utils(monitor)

  uvm_analysis_port#(NNI_cell) fromMonitor;

  virtual Utopia tx_if;

  function new(string name="monitor", uvm_component parent);
    super.new(name, parent);
  endfunction : new

int portn;

function void build_phase(uvm_phase phase);
  super.build_phase(phase);

  if (!uvm_config_db #(virtual Utopia)::get (this,"", "tx_if", tx_if) )
  begin
    uvm_config_db #(int)::dump(); 
    `uvm_fatal("monitor", "No top_receive_if");
  end
    fromMonitor = new("fromMonitor", this); 

    if (!uvm_config_db #(int)::get (this,"", "portn", portn) )
  begin
    uvm_config_db #(int)::dump(); 
    `uvm_fatal("monitor", "No portn configuration");
  end

  
endfunction : build_phase

task run();
   NNI_cell c;
      
   forever begin
      receive(c);
      c.portID=portn;
     fromMonitor.write(c);

    end
      
endtask : run

task receive(output NNI_cell c);
   ATMCellType Pkt;

   tx_if.cbt.clav <= 1;
   while (tx_if.cbt.soc !== 1'b1 && tx_if.cbt.en !== 1'b0)
     @(tx_if.cbt);
   for (int i=0; i<=52; i++) begin
      // If not enabled, loop
      while (tx_if.cbt.en !== 1'b0) @(tx_if.cbt);
      
      Pkt.Mem[i] = tx_if.cbt.data;
      @(tx_if.cbt);
   end

   tx_if.cbt.clav <= 0;

   c = new();
   c.unpack(Pkt);
   c.display($sformatf("@%0t: Mon: ", $time));
   
endtask : receive
endclass : monitor


//---------------------------------------------------------------------------
// new(): construct an object
//---------------------------------------------------------------------------


//---------------------------------------------------------------------------
// run(): Run the monitor
//---------------------------------------------------------------------------


//---------------------------------------------------------------------------
// receive(): Read a cell from the DUT output, pack it into a NNI cell
//---------------------------------------------------------------------------

