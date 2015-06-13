`ifndef HOST_DRIVER__SV
`define HOST_DRIVER__SV

class host_driver extends uvm_driver#(host_item);
  `uvm_component_utils(host_driver)

  // Config
  host_cfg  m_cfg;

  // Interface
  virtual host_if.drv_mp m_vif;

  // Analysis Port
  uvm_analysis_port#(host_item) m_req_analysis_port;
  uvm_analysis_port#(host_item) m_rsp_analysis_port;

  // Constructor
  function new (string name = "host_driver", uvm_component parent = null);
    super.new(name, parent);
  endfunction: new

  // Phase Methods
  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern virtual task run_phase(uvm_phase phase);

  // Helper Methods
  extern virtual task drv_init();
  extern virtual task drv_interface();
  extern virtual task drv_write(int addr, int wdata);
  extern virtual task drv_read(int addr, output int rdata);

endclass: host_driver

function void host_driver::build_phase(input uvm_phase phase);
  super.build_phase(phase);

  // Grab the Config
  if (!uvm_config_db#(host_cfg)::get(this, "", "host_cfg", m_cfg)) begin
    `uvm_fatal(get_name(), "Failed to Grab host_cfg from Config DB")
  end

  // Build the Analysis Ports
  m_req_analysis_port = new("m_req_analysis_port", this);
  m_rsp_analysis_port = new("m_rsp_analysis_port", this);

endfunction: build_phase


function void host_driver::connect_phase(input uvm_phase phase);
  // Grab the Config
  if (!uvm_config_db#(virtual host_if.drv_mp)::get(this, "", "host_vif_drv", m_vif)) begin
    `uvm_fatal(get_name(), "Failed to Grab host_vif_drv from Config DB")
  end

endfunction: connect_phase

task host_driver::run_phase(uvm_phase phase);
  super.run_phase(phase);

  drv_init();

  fork
    drv_interface();
  join

endtask: run_phase

task host_driver::drv_init();

  // Don't use CB here .. want to init before clock starts
  m_vif.sel = 0;
  m_vif.wr = 0;
  m_vif.addr = 0;
  m_vif.wdata = 0;

endtask: drv_init


task host_driver::drv_interface();

  forever begin
    // Get and item from the seq item port
    seq_item_port.get(req);
    m_req_analysis_port.write(req);

    // Construct Response
    rsp = RSP::type_id::create("rsp", this);

    // Copy Req ID to Rsp ID
    rsp.copy(req); // copy contents
    rsp.set_id_info(req); // copy sequence item id

    // Drive Interface
    case(req.m_host_access_kind)
      HOST_ACCESS_KIND_WR: begin
        drv_write(req.m_addr, req.m_wdata);
      end
      HOST_ACCESS_KIND_RD: begin
        drv_read(req.m_addr, rsp.m_rdata);
      end
    endcase

    // Provide RSP to analysis port
    m_rsp_analysis_port.write(rsp);

    // Return Response to Sequence
    seq_item_port.put(rsp);

  end
endtask: drv_interface

task host_driver::drv_write(int addr, int wdata);
  `uvm_info(get_name(), $psprintf("drv_write: addr: 0x%0h, data: 0x%0h", addr, wdata), UVM_HIGH)

  m_vif.drv_cb.sel <= 1'b1;
  m_vif.drv_cb.wr <= 1'b1;
  m_vif.drv_cb.addr <= addr;
  m_vif.drv_cb.wdata <= wdata;
  @(m_vif.drv_cb);
  drv_init();
endtask: drv_write

task host_driver::drv_read(int addr, output int rdata);

  `uvm_info(get_name(), $psprintf("drv_read: addr: 0x%0h", addr), UVM_HIGH)
  m_vif.drv_cb.sel <= 1'b1;
  m_vif.drv_cb.wr <= 1'b0;
  m_vif.drv_cb.addr <= addr;
  @(m_vif.drv_cb);
  rdata = m_vif.drv_cb.rdata;
  `uvm_info(get_name(), $psprintf("drv_read: addr: 0x%0h, data: 0x%0h", addr, rdata), UVM_HIGH)
  drv_init();
endtask: drv_read


`endif // HOST_DRIVER__SV