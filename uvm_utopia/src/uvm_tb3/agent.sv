import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../src/uvm_tb3/driver.sv"  
`include "../src/uvm_tb3/monitor.sv"  


class agent extends uvm_agent;
  `uvm_component_utils(agent)

  driver    dr;
  utopia_sequencer seqcr;
  monitor mon;

 function new (string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
 
  // build_phase
  function void build_phase(uvm_phase phase);
    virtual Utopia uif;
    int portn;
      virtual Utopia tx_if;

    super.build_phase(phase);


     if (!uvm_config_db #(virtual Utopia)::get (this, "", "uif", uif) )
      begin
        uvm_config_db #(int)::dump(); 
        `uvm_fatal("agnt", "No top_receive_if");
    end

     if (!uvm_config_db #(virtual Utopia)::get (this, "", "tx_if", tx_if) )
      begin
        uvm_config_db #(int)::dump(); 
        `uvm_fatal("agnt", "No top_receive_tx_if");
    end

      uvm_config_db #(int)::get (this,"", "portn", portn);
      uvm_config_db #(int)::set (this,"monitor", "portn", portn);
      mon=monitor::type_id::create("monitor",this);
      dr = driver::type_id::create("driver", this);
      seqcr = utopia_sequencer::type_id::create("sequencer", this);
      uvm_config_db #(virtual Utopia.TB_Rx)::set (this,"driver", "uif", uif);
      uvm_config_db #(virtual Utopia)::set (this,"monitor", "tx_if", tx_if);

      endfunction : build_phase

 
  // connect_phase
  function void connect_phase(uvm_phase phase);
      dr.seq_item_port.connect(seqcr.seq_item_export);
  endfunction : connect_phase
 
endclass : agent



