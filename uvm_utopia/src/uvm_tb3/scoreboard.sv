import uvm_pkg::*;
`include "uvm_macros.svh"
`include "../src/uvm_tb3/seq_cell.sv"  // include external definitions

`include "../src/uvm_tb3/config.sv"  // include external definitions


class Expect_cells;
   NNI_cell q[$];
   int iexpect, iactual;
endclass : Expect_cells

`uvm_analysis_imp_decl(UNI_cell)

class scoreboard extends uvm_scoreboard;
 
  `uvm_component_utils(scoreboard)

    //uvm_analysis_imp#(wrapper_cell, scoreboard) item_collected_export;

  uvm_analysis_port#(NNI_cell) fromMonitor;
  uvm_tlm_analysis_fifo#(NNI_cell) get_cell_fMon;

  uvm_analysis_port#(UNI_cell) fromDriver;
  uvm_tlm_analysis_fifo#(UNI_cell) get_cell;

  UNI_cell cellFromDriver;
  NNI_cell cellFromMonitor;
  //uvm_analysis_imp#(UNI_cell, scoreboard) item_collected_export2;
  // new - constructor

  Expect_cells expect_cells[];
   NNI_cell cellq[$];
   int iexpect, iactual;
   Config cfg;
   int nErrors;

  function new (string name, uvm_component parent);
    super.new(name, parent);

  endfunction : new
 
  function void build_phase(uvm_phase phase);
    super.build_phase(phase);

    //for(int i=0;i<4;i++)begin
      fromMonitor = new("fromMonitor", this);
      //item_collected_export2 = new("item_collected_export2", this);
      fromDriver = new("fromDriver", this);
    //end
    get_cell = new("get_cell", this);
    get_cell_fMon = new("get_cell_fMon",this);

    expect_cells = new[`TxPorts];
   foreach (expect_cells[i])
    expect_cells[i] = new();

  endfunction: build_phase

  function void connect_phase(uvm_phase phase);

      //  for(int i=0;i<4;i++)begin

    fromDriver.connect(get_cell.analysis_export);
    fromMonitor.connect(get_cell_fMon.analysis_export);
  //end
  endfunction: connect_phase

  task run_phase(uvm_phase phase);
    fork
  get_uniCell(get_cell,phase);
  check_actual(get_cell_fMon,phase);
join
  
  endtask
  // write

  task get_uniCell(uvm_tlm_analysis_fifo #(UNI_cell) fifo_fromDriver,uvm_phase phase);

    UNI_cell c;
    ATMCellType Pkt;
    CellCfgType CellCfg;
    int portn;
forever begin
      NNI_cell ncell;
      phase.raise_objection(this);
      fifo_fromDriver.get(c);
      c.pack(Pkt);
      ncell = c.to_NNI();
      CellCfg = top.squat.lut.read(ncell.VPI);
    for(int i=0; i<`RxPorts; i++)
     if (CellCfg.FWD[i]) begin
       expect_cells[i].q.push_back(ncell); 
        expect_cells[i].iexpect++;


        iexpect++;

     end

      phase.drop_objection(this);
);

  end
  endtask

  task check_actual(uvm_tlm_analysis_fifo #(NNI_cell) fifo_fromMonitor, uvm_phase phase);
   NNI_cell ncell;
   int match_idx;
   int portn;
   forever begin
      phase.raise_objection(this);
      fifo_fromMonitor.get(ncell);
      portn = ncell.portID;


   if (expect_cells[portn].q.size() == 0) begin
      $display("@%0t: ERROR: %m cell not found because scoreboard for TX%0d empty", $time, portn);
      ncell.display("Not Found: ");
      nErrors++;
      continue;
   end

   expect_cells[portn].iactual++;
   iactual++;

   foreach (expect_cells[portn].q[i]) begin
    expect_cells[portn].q[i].display("cell From Driver:");
    ncell.display("cell From Monitor:");


      if (expect_cells[portn].q[i].compare(ncell)) begin
         $display("@%0t: Match found for cell", $time);
        expect_cells[portn].q.delete(i);
       return;
      end
   end

    $display("@%0t: ERROR: %m cell not found", $time);
   ncell.display("Not Found: ");
   nErrors++;
  end
endtask 
     
 
endclass : scoreboard