`timescale 1 ns / 1 ps

// ====================
//
// Top-Level HDL Design
//
// NOTE: This module must instantiate the
// sys module to generate clk and rst_n
// for the rest of the user logic design.
//
// By Nathan Petersen
// April 1, 2020
// 
// ====================

module top(CLK_IN, LED1, LED2, LED3, LED4, LED5);

input CLK_IN;
output LED1, LED2, LED3, LED4, LED5;

localparam WIDTH = 32;

reg [WIDTH-1:0] counter;

// =====================
// Global System Signals
// (clk, rst_n)
// =====================
wire clk, rst_n;
sys sys_inst(
	.CLK_IN(CLK_IN),
	.clk(clk),
	.rst_n(rst_n)
);

always @(posedge clk, negedge rst_n) begin
	if (~rst_n)
		counter <= 32'h0;
	else
		counter <= counter + 1;
end

assign LED1 = counter[WIDTH-1];
assign LED2 = counter[WIDTH-2];
assign LED3 = counter[WIDTH-3];
assign LED4 = counter[WIDTH-4];
assign LED5 = counter[WIDTH-5];

endmodule