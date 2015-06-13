`ifndef DUT_CFG__SV
`define DUT_CFG__SV

class dut_cfg extends uvm_object;
  `uvm_object_utils(dut_cfg)

  // Member Variables to define how the DUT Env
  // None Yet..

  // Constructor
  function new (string name = "dut_cfg");
    super.new(name);
  endfunction: new

  // Field Macros
  // None Yet..  `uvm_object_utils(dut_cfg) will become `uvm_object_utils_begin(dut_cfg) .. with `uvm_field_.. following

endclass: dut_cfg


`endif // DUT_CFG__SV