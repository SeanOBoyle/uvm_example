`ifndef DUT_VIRTUAL_SEQUENCER__SV
`define DUT_VIRTUAL_SEQUENCER__SV

class dut_virtual_sequencer extends uvm_virtual_sequencer;
  `uvm_component_utils(dut_virtual_sequencer)

  // Handles to All Sequencers in DUT Env
  //  NOTE: Assigned in .connect_phase() of the dut_env
  host_sequencer m_host_sequencer_h;

  // Constructor
  function new(string name = "dut_virtual_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

endclass: dut_virtual_sequencer

`endif