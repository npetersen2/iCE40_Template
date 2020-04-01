`timescale 1 ns / 1 ps

// ===============================
// Global System Signal Generation
//
// Low-level hardware configuration
// to generate the global clk signal
// and asynchronous rst_n signal.
//
// =====
// Usage
// =====
//
// Top-level designs must include
// the following HDL:
//
//    // =====================
//    // Global System Signals
//    // (clk, rst_n)
//    // =====================
//    wire clk, rst_n;
//    sys sys_inst(
//    	.CLK_IN(CLK_IN),
//    	.clk(clk),
//    	.rst_n(rst_n)
//    );
//
// By Nathan Petersen
// April 1, 2020
//
// ===============================

module sys(CLK_IN, clk, rst_n);

input CLK_IN;
output clk, rst_n;

// =======================
// System Clock Generation
// 
// Generate 120MHz clock signal for
// our logic using the device PLL.
// =======================
wire pll_locked;
pll myPLL(
	.clock_in(CLK_IN),
	.global_clock(clk),
	.locked(pll_locked)
);

// =======================
// Global Asynchronous Reset
//
// From: https://stackoverflow.com/questions/38030768
//
// Lattice iCE40 FPGAs do not have a global reset signal!
//
// Therefore, we can simulate one by using the PLL LOCK output.
// When the FPGA first powers on, the PLL must initialize and
// acquire a lock onto the input reference clock. This takes
// 10s of cycles, so we simply assert the reset signal while
// the PLL is not locked.
//
// Since it is unclear if the PLL LOCK output is in our clock
// domain, we synchronize it before using it to prevent
// meta-stability issues.
//
// =======================
reg [3:0] pll_locked_ff;
always @(posedge CLK_IN)
	pll_locked_ff <= {pll_locked_ff, pll_locked};
assign rst_n = pll_locked_ff[3];


endmodule