`ifndef DUT_BASE_VSEQ__SV
`define DUT_BASE_VSEQ__SV

class dut_base_vseq extends uvm_sequence;
  `uvm_object_utils(dut_base_vseq)  // register with the factory
  `uvm_declare_p_sequencer(dut_virtual_sequencer) // declare p_sequencer -- since virtual sequence

  // Constructor
  function new(string name = "dut_base_vseq");
    super.new(name);
  endfunction

  // Body
  extern virtual task body();

  // Helper Methods
  //  common methods / sequences used by derived virtual sequences
  extern virtual task host_write(int unsigned addr, int unsigned data);
  extern virtual task host_read(int unsigned addr, output int unsigned data);

endclass: dut_base_vseq


task dut_base_vseq::body();
  // Don't Call super.body() .. doing so produces a warning - uvm thinks that body was not overridden
endtask:body


task dut_base_vseq::host_write(int unsigned addr, int unsigned data);
  host_nominal_seq host_nominal_seq_h;
  `uvm_info(get_name(), $psprintf("host_write: addr: 0x%0h, data: 0x%0h", addr, data), UVM_LOW)
  host_nominal_seq_h = host_nominal_seq::type_id::create("host_nominal_seq_h", null, get_full_name());
  if(!host_nominal_seq_h.randomize() with {
    m_host_access_kind == HOST_ACCESS_KIND_WR;
    m_addr == local::addr;
    m_wdata == local::data;
  }) begin
    `uvm_fatal(get_name(), "Randomize Failed")
  end
  host_nominal_seq_h.start(p_sequencer.m_host_sequencer_h);
endtask: host_write

task dut_base_vseq::host_read(int unsigned addr, output int unsigned data);
  host_nominal_seq host_nominal_seq_h;
  `uvm_info(get_name(), $psprintf("host_read: addr: 0x%0h", addr), UVM_LOW)
  host_nominal_seq_h = host_nominal_seq::type_id::create("host_nominal_seq_h", null, get_full_name());
  if(!host_nominal_seq_h.randomize() with {
    m_host_access_kind == HOST_ACCESS_KIND_RD;
    m_addr == local::addr;
  }) begin
    `uvm_fatal(get_name(), "Randomize Failed")
  end
  host_nominal_seq_h.start(p_sequencer.m_host_sequencer_h);
  data = host_nominal_seq_h.m_rdata;
  `uvm_info(get_name(), $psprintf("host_read: addr: 0x%0h, data: 0x%0h", addr, data), UVM_LOW)
endtask: host_read

`endif // DUT_BASE_VSEQ