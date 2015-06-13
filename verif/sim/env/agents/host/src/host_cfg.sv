`ifndef HOST_CFG__SV
`define HOST_CFG__S

class host_cfg extends uvm_object;

  // Member Variables to define how the Host Agent is to be built
  uvm_active_passive_enum m_uvm_active_passive_h;

  // Constructor
  function new (string name = "host_cfg");
    super.new(name);
  endfunction: new

  // Field Macros
  `uvm_object_utils_begin(host_cfg)
    `uvm_field_enum(uvm_active_passive_enum, m_uvm_active_passive_h, UVM_ALL_ON)
  `uvm_object_utils_end

endclass: host_cfg


`endif