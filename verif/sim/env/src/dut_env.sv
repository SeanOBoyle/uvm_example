`ifndef DUT_ENV__SV
`define DUT_ENV__SV

class dut_env extends uvm_env;
  `uvm_component_utils(dut_env)

  // Env Config
  dut_cfg m_dut_cfg_h;

  // Virtual Sequencer
  dut_virtual_sequencer m_dut_virtual_sequencer_h;

  // Member Agents
  host_agent m_host_agent_h;

  function new (string name = "dut_env", uvm_component parent = null);
    super.new(name, parent);
  endfunction:new

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass: dut_env

function void dut_env::build_phase(uvm_phase phase);
  if(!uvm_config_db#(dut_cfg)::get(this, "", "dut_cfg", m_dut_cfg_h)) begin
    `uvm_fatal(get_name(), "Failed to Grab dut_cfg from Config DB")
  end

  m_dut_virtual_sequencer_h = dut_virtual_sequencer::type_id::create("m_dut_virtual_sequencer_h", this);

  m_host_agent_h = host_agent::type_id::create("m_host_agent_h", this);

endfunction: build_phase

function void dut_env::connect_phase(uvm_phase phase);
  // Connect Agents to Virtual Sequencer
  m_dut_virtual_sequencer_h.m_host_sequencer_h = m_host_agent_h.m_host_sequencer;
endfunction: connect_phase



`endif // DUT_ENV__SV