`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 29.10.2019 23:50:20
// Design Name: 
// Module Name: BRAM_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module BRAM_tb();
reg clk;
wire [3:0] A;
wire clk_out;
wire [6:0] seg; // Declaring Input and Output variables
initial
clk = 0;
always
#2 clk=~clk; // Simulating Clock of Period 2ns
B_ram_read inst(.clk(clk),.A(A),.clk_out(clk_out),.seg(seg)); //Calling the main module
endmodule
