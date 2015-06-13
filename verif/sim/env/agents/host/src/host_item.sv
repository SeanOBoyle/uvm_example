`ifndef HOST_ITEM__SV
`define HOST_ITEM__SV

class host_item extends uvm_sequence_item;

  // Rand Members
  rand host_access_kind_t m_host_access_kind;
  rand bit [3:0] m_addr;
  rand bit [7:0] m_wdata;
  bit [7:0] m_rdata;

  // Consraints
  //  if any..

  // Constructor
  function new (string name = "host_item");
    super.new(name);
  endfunction: new

  // Field Macros
  `uvm_object_utils_begin(host_item)
    `uvm_field_enum(host_access_kind_t, m_host_access_kind, UVM_ALL_ON)
    `uvm_field_int(m_addr, UVM_ALL_ON)
    `uvm_field_int(m_wdata, UVM_ALL_ON)
    `uvm_field_int(m_rdata, UVM_ALL_ON)
  `uvm_object_utils_end


endclass: host_item

`endif // HOST_ITEM__SV