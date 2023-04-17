`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2019 08:29:23 PM
// Design Name: 
// Module Name: multiply_tb
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


module multiply_tb(

    );
endmodule

module multiply_tb;
    reg [31:0] ain;
    reg [31:0] bin;
    wire [63:0] dout;
    
    multiplier UUT (.ain(ain), .bin(bin), .dout(dout));
    reg [31:0] i;
 
    initial
    begin
    for(i = 0; i < 31; i = i+1) begin
        ain = 10*i;
        bin = i+1;
        #20;
    end
    
    #20;
    ain = 32'b11111111111111111111111111111111;
    bin = 32'b11111111111111111111111111111111;
    end
    
endmodule
