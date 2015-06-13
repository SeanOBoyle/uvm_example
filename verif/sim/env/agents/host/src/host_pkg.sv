`ifndef HOST_PKG__SV
`define HOST_PKG__SV

package host_pkg;

  // Custom Types
  typedef enum {
    HOST_ACCESS_KIND_WR,
    HOST_ACCESS_KIND_RD
  } host_access_kind_t;

  `include "host_item.sv"
  `include "host_cfg.sv"
  `include "host_sequencer.sv"
  `include "host_driver.sv"
  `include "host_monitor.sv"
  `include "host_agent.sv"
  `include "host_sequence_list.sv"

endpackage: host_pkg


`endif // HOST_PKG__SV
