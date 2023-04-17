`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2019 07:34:42 PM
// Design Name: 
// Module Name: add_tb
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


module add_tb;

    reg [31:0] ain;
    reg [31:0] bin;
    wire [31:0] dout;
    wire overflow;
    
    adder UUT (.ain(ain), .bin(bin), .dout(dout), .overflow(overflow));
    reg [31:0] i;
 
    initial
    begin
    for(i = 0; i < 31; i = i + 1) begin
        ain = i;
        bin = i+1;
        #20;
    end
    
    #20;
    ain = 32'b11111111111111111111111111111111;
    bin = 32'b11111111111111111111111111111111;
    end
    
endmodule
