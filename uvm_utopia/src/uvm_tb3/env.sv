import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../src/uvm_tb3/agent.sv"  // include external definitions
`include "../src/uvm_tb3/scoreboard.sv"

class env extends uvm_env;
    
  `uvm_component_utils(env)

  agent agents[`RxPorts];
  scoreboard scb;
     
  // new - constructor
  function new(string name, uvm_component parent);
    super.new(name, parent);
  endfunction : new
 
  // build_phase
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    /*foreach (monitors[i]) begin
      monitors[i] = monitor::type_id::create($sformatf("monitors_%0d",i), this);
    end*/


    foreach (agents[i]) begin

      uvm_config_db #(int)::set (this,$sformatf("agents_%0d",i), "portn", i);

      agents[i] = agent::type_id::create($sformatf("agents_%0d",i), this);
    end
     scb  = scoreboard::type_id::create("scb", this);

  endfunction : build_phase

  function void connect_phase(uvm_phase phase);


    /* foreach (monitors[i]) begin
           monitors[i].fromMonitor.connect(scb.fromMonitor);
        end*/


       foreach (agents[i]) begin
        agents[i].dr.fromDriver.connect(scb.fromDriver);
        agents[i].mon.fromMonitor.connect(scb.fromMonitor);
    end 


  endfunction : connect_phase
 
endclass : env