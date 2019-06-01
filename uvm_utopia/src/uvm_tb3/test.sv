import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../src/uvm_tb3/env.sv"  // include external definitions
`include "../src/uvm_tb3/sequence.sv"  // include external definitions
`include "../src/uvm_tb3/cpu_ifc.sv"  // include external definitions
`include "../src/uvm_tb3/CPU_driver.sv"  // include external definitions


class test extends uvm_test;
 
  `uvm_component_utils(test)
 
  env utopia_env;
  utopia_sequence seq;
 
  CPU_driver cpu;
  Config cfg;
  vCPU_T mif;

  function new(string name = "test",uvm_component parent=null);
    super.new(name,parent);
  endfunction : new
 
  virtual function void build_phase(uvm_phase phase);
    super.build_phase(phase);
 
    utopia_env = env::type_id::create("utopia_env", this);
    seq = utopia_sequence::type_id::create("seq");

    cfg = new(`RxPorts, `TxPorts);
    if(!(uvm_config_db#(vCPU_T)::get(null, "*", "mif", mif))) begin
      `uvm_fatal("dr", "fail to build cpu_if");
    end
     cpu = new(mif, cfg);
  endfunction : build_phase
 
  task run_phase(uvm_phase phase);

    phase.raise_objection(this);

    cpu.run();


  foreach (seq.sequences[i]) begin
    seq.sequences[i] = utopia_env.agents[i].seqcr;
  end

  foreach (seq.sequences[i]) begin
  seq.start(seq.sequences[i]);  
  end


    phase.drop_objection(this);
  endtask : run_phase

  function void end_of_elaboration();
    uvm_top.print_topology();
  endfunction : end_of_elaboration
 
endclass : test