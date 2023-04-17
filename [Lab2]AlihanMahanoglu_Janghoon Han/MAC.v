`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2019 08:38:18 PM
// Design Name: 
// Module Name: MAC
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


module MAC #(
    parameter BITWIDTH = 32
)
(
    input [BITWIDTH-1:0] ain,
    input [BITWIDTH-1:0] bin,
    input en,
    input clk,
    output [2*BITWIDTH-1:0] dout
    );
    
    reg [2*BITWIDTH-1:0] dout;
    reg [2*BITWIDTH-1:0] tmp = 0;
    
    always @(posedge clk) begin
        if(en) begin
            dout = ain*bin + tmp;
            tmp = dout;
        end
        else dout = 0;
    end
endmodule
