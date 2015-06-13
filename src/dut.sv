// Example DUT -- a host interface with a memory

`timescale 1ns/1ps

module dut (
  input wire host_clk_i,
  input wire reset_n_i,

  input wire host_sel_i,
  input wire host_wr_i,
  input wire [3:0] host_addr_i,
  input wire [7:0] host_wdata_i,
  output wire [7:0] host_rdata_o
  );


logic [7:0] host_rdata_d;
logic [15:0][7:0] memory_d;
logic [15:0][7:0] memory_q;


assign host_rdata_o = host_rdata_d;


always_comb begin
  host_rdata_d = 0;
  memory_d = memory_q;
  if (host_sel_i) begin
    if (host_wr_i) begin
      memory_d[host_addr_i] = host_wdata_i;
    end
    else begin
      host_rdata_d = memory_q[host_addr_i];
    end
  end
end


always_ff @ (posedge host_clk_i or negedge reset_n_i) begin
  if (!reset_n_i) begin
    memory_q <= 'd0;
  end
  else begin
    memory_q <= memory_d;
  end
end


endmodule: dut