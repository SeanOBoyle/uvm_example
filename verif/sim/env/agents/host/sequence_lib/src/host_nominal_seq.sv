`ifndef HOST_NOMINAL_SEQ__SV
`define HOST_NOMINAL_SEQ__SV

// Nominal Seq -- just a wrapper for the item / driver interaction
//  simplifies the user api from start, finish, rand, get to just start
class host_nominal_seq extends uvm_sequence#(host_item);
  `uvm_object_utils(host_nominal_seq)

  // Rand Members
  rand host_access_kind_t m_host_access_kind;
  rand bit [3:0] m_addr;
  rand bit [7:0] m_wdata;
  bit [7:0] m_rdata;

  // Consraints
  //  if any..

  // Constructor
  function new(string name = "host_nominal_seq");
    super.new(name);
  endfunction: new

  // Sequence Body
  extern virtual task body();

endclass: host_nominal_seq

task host_nominal_seq::body();

  req = REQ::type_id::create("req", null, get_full_name());

  start_item(req);
  if (!req.randomize() with {
    m_host_access_kind == local::m_host_access_kind;
    m_addr == local::m_addr;
    m_wdata == local::m_wdata;
  }) begin
    `uvm_fatal(get_name(), "randomize failed")
  end
  finish_item(req);
  get_response(rsp);

  m_rdata = rsp.m_rdata;


endtask: body

`endif // HOST_NOMINAL_SEQ__SV