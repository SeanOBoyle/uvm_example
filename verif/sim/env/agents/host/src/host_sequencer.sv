`ifndef HOST_SEQUENCER__SV
`define HOST_SEQUENCER__SV

class host_sequencer extends uvm_sequencer#(host_item);
  `uvm_component_utils(host_sequencer)

  // Constructor
  function new (string name = "host_sequencer", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

endclass: host_sequencer

`endif // HOST_SEQUENCER__SV