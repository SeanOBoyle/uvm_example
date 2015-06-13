`ifndef DUT_TEST_BASE__SV
`define DUT_TEST_BASE__SV

class dut_test_base extends uvm_test;
  `uvm_component_utils(dut_test_base)

  // Configuration
  dut_cfg m_dut_cfg_h;
  host_cfg m_host_cfg_h;

  // DUT Environment
  dut_env m_dut_env_h;

  // Environment Virtual Sequencer
  dut_virtual_sequencer m_virtual_sequencer_h; // Virtual Sequencer Handle


  function new(string name = "dut_test_base", uvm_component parent = null);
    super.new(name, parent);
  endfunction

  extern virtual function void build_phase(uvm_phase phase);
  extern virtual function void connect_phase(uvm_phase phase);
  extern task run_phase(uvm_phase phase);

  extern task run_vseq_from_plusarg();

  // All Dropped Component Callback
  extern virtual task all_dropped(uvm_objection objection, uvm_object source_obj, string description, int count);


endclass: dut_test_base

function void dut_test_base::build_phase(uvm_phase phase);

  //
  // Create, Configure, Set Config Objects
  //

  // DUT Config
  m_dut_cfg_h = dut_cfg::type_id::create("m_dut_cfg_h", this);
  // no settings..
  uvm_config_db#(dut_cfg)::set(this, "*", "dut_cfg", m_dut_cfg_h);

  // Host Interface Agent Config
  m_host_cfg_h = host_cfg::type_id::create("m_host_cfg_h", this);
  m_host_cfg_h.m_uvm_active_passive_h = UVM_ACTIVE;
  uvm_config_db#(host_cfg)::set(this, "*", "host_cfg", m_host_cfg_h);

  //
  // Create Environment
  //
  m_dut_env_h = dut_env::type_id::create("m_dut_env_h", this);

endfunction

function void dut_test_base::connect_phase(input uvm_phase phase);
  m_virtual_sequencer_h = m_dut_env_h.m_dut_virtual_sequencer_h;
endfunction

task dut_test_base::run_phase(uvm_phase phase);

  phase.raise_objection(this, "dut_test_base run_phase");

  super.run_phase(phase);
  run_vseq_from_plusarg();

  phase.drop_objection(this, "dut_test_base run_phase");

endtask: run_phase

task dut_test_base::run_vseq_from_plusarg();
  uvm_object tmp;
  string vseq_testname;
  uvm_sequence#() test_plusarg_vseq_h; // Typed Sequence

  if(!$value$plusargs( "UVM_VSEQ_TESTNAME=%s", vseq_testname ) ) begin
    `uvm_fatal( get_type_name(), "Required plusarg +UVM_VSEQ_TESTNAME not defined" )
  end

  tmp = factory.create_object_by_name(vseq_testname, m_virtual_sequencer_h.get_full_name(), "test_plusarg_vseq_h");

  if(!$cast( test_plusarg_vseq_h, tmp)) begin
    `uvm_fatal( get_type_name(), $psprintf("cast failed - %s is not a uvm_sequence",vseq_testname) )
  end

  if(test_plusarg_vseq_h == null) begin
    `uvm_fatal(get_type_name(), $psprintf( "Test vseq is null; This test probably doesn't exist: %s", vseq_testname))
  end

  if (!test_plusarg_vseq_h.randomize()) begin
    `uvm_fatal(get_type_name(), "Randomize failed for the initial vseq")
  end

  `uvm_info(get_type_name(), "Running test sequence", UVM_MEDIUM)
  test_plusarg_vseq_h.start(m_virtual_sequencer_h);

endtask: run_vseq_from_plusarg


task dut_test_base::all_dropped(uvm_objection objection, uvm_object source_obj, string description, int count);
  int end_of_test_drain_time_us;
  super.all_dropped(objection, source_obj, description, count);

  end_of_test_drain_time_us = 5;

  if (objection.get_type_name() == "uvm_test_done") begin
    `uvm_info(get_type_name(), $psprintf( "\n%s\nEnd of Test Objections Dropped - test ending in %0d us", objection.sprint(), end_of_test_drain_time_us), UVM_NONE)
    #(end_of_test_drain_time_us*1us);
  end
endtask


`endif // DUT_TEST_BASE__SV