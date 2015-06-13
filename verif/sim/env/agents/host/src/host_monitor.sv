`ifndef HOST_MONITOR__SV
`define HOST_MONITOR__SV

class host_monitor extends uvm_monitor;
  `uvm_component_utils(host_monitor)

  // Config
  host_cfg  m_cfg;

  // Interface
  virtual host_if.mon_mp m_vif;

  // Analysis Port
  uvm_analysis_port#(host_item) m_analysis_port;

  // Constructor
  function new (string name = "host_monitor", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  // Phase Methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

  // Helper Methods
  extern virtual task mon_interface();

endclass: host_monitor

function void host_monitor::build_phase(input uvm_phase phase);
  super.build_phase(phase);

  // Grab the Config
  if (!uvm_config_db#(host_cfg)::get(this, "", "host_cfg", m_cfg)) begin
    `uvm_fatal(get_name(), "Failed to Grab host_cfg from Config DB")
  end

  // Build the Analysis Ports
  m_analysis_port = new("m_analysis_port", this);

endfunction: build_phase


function void host_monitor::connect_phase(input uvm_phase phase);
  // Grab the Config
  if (!uvm_config_db#(virtual host_if.mon_mp)::get(this, "", "host_vif_mon", m_vif)) begin
    `uvm_fatal(get_name(), "Failed to Grab host_vif_mon from Config DB")
  end

endfunction: connect_phase

task host_monitor::run_phase(uvm_phase phase);
  super.run_phase(phase);

  fork
    mon_interface();
  join

endtask: run_phase

task host_monitor::mon_interface();

  host_item mon_item_h;

  forever begin

    // Wait for a valid access
    @(m_vif.mon_cb);
    if (m_vif.mon_cb.sel) begin
      // Construct Response
      mon_item_h = host_item::type_id::create("mon_item", this);

      if (m_vif.mon_cb.wr) begin
        mon_item_h.m_host_access_kind = HOST_ACCESS_KIND_WR;
        mon_item_h.m_addr = m_vif.mon_cb.addr;
        mon_item_h.m_wdata = m_vif.mon_cb.wdata;
      end
      else begin
        mon_item_h.m_host_access_kind = HOST_ACCESS_KIND_RD;
        mon_item_h.m_addr = m_vif.mon_cb.addr;
        mon_item_h.m_rdata = m_vif.mon_cb.rdata;
      end

      // Write the Item out
      m_analysis_port.write(mon_item_h);

    end
  end

endtask: mon_interface



`endif // HOST_MONITOR__SV