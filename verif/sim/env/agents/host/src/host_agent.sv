`ifndef HOST_AGENT__SV
`define HOST_AGENT__SV

class host_agent extends uvm_agent;
  `uvm_component_utils(host_agent)

  host_cfg m_cfg_h;

  // Analysis Fifos
  uvm_analysis_port#(host_item) m_driver_req_analysis_port;
  uvm_analysis_port#(host_item) m_driver_rsp_analysis_port;
  uvm_analysis_port#(host_item) m_monitor_analysis_port;

  // Child Components
  host_sequencer m_host_sequencer;
  host_driver m_host_driver;
  host_monitor m_host_monitor;

  // Constructor
  function new(string name = "host_agent", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  // Phase Methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);

endclass: host_agent

function void host_agent::build_phase(uvm_phase phase);
  super.build_phase(phase);

  if(!uvm_config_db#(host_cfg)::get(this, "", "host_cfg", m_cfg_h)) begin
    `uvm_fatal(get_name(), "Failed to Grab host_cfg from Config DB")
  end

  if (m_cfg_h.m_uvm_active_passive_h == UVM_ACTIVE) begin
    m_host_sequencer = host_sequencer::type_id::create("m_host_sequencer", this);
    m_host_driver = host_driver::type_id::create("m_host_driver", this);
    m_driver_req_analysis_port = new("m_driver_req_analysis_port", this);
    m_driver_rsp_analysis_port = new("m_driver_rsp_analysis_port", this);
  end

  m_host_monitor = host_monitor::type_id::create("m_host_monitor", this);
  m_monitor_analysis_port = new("m_monitor_analysis_port", this);

endfunction: build_phase


function void host_agent::connect_phase(input uvm_phase phase);
  super.connect_phase(phase);

  // Connect
  if (m_cfg_h.m_uvm_active_passive_h == UVM_ACTIVE) begin
    m_host_driver.seq_item_port.connect(m_host_sequencer.seq_item_export);
    m_host_driver.m_req_analysis_port.connect(m_driver_req_analysis_port);
    m_host_driver.m_rsp_analysis_port.connect(m_driver_rsp_analysis_port);
  end

  m_host_monitor.m_analysis_port.connect(m_monitor_analysis_port);

endfunction: connect_phase



`endif // HOST_AGENT__SV