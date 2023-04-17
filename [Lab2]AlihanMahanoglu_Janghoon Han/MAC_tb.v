`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/20/2019 08:54:57 PM
// Design Name: 
// Module Name: MAC_tb
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


module MAC_tb(

    );
endmodule

module MAC_tb;
    reg [31:0] ain;
    reg [31:0] bin;
    reg en;
    reg clk;
    wire [63:0] dout;
    
    MAC UUT (.ain(ain), .bin(bin), .en(en), .clk(clk), .dout(dout));
    reg [31:0] i;
 
    always begin
        clk = 0;
        forever #10 clk = ~clk;        
    end
    
    always begin
        en = 0;
        forever #100 en = ~en;        
    end
 
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