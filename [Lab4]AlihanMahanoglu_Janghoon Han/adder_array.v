`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2019 08:50:12 PM
// Design Name: 
// Module Name: adder_array
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

module adder(ain, bin, dout, overflow);
    input [31:0] ain;
    input [31:0] bin;
    output [31:0] dout;
    output overflow;

    assign {overflow, dout} = ain+bin;
endmodule

module adder_array(cmd, ain0, ain1, ain2, ain3, bin0, bin1, bin2, bin3, dout0, dout1, dout2, dout3, overflow);
    
    input [2:0] cmd;
    input [31:0] ain0, ain1, ain2, ain3;
    input [31:0] bin0, bin1, bin2, bin3;
    output [31:0] dout0, dout1, dout2, dout3;
    output [3:0] overflow;
    
    wire [31:0] my_ain [3:0];
    wire [31:0] my_bin [3:0];
    wire [31:0] my_dout [3:0];
    
    assign my_ain[0] = ain0;
    assign my_ain[1] = ain1;
    assign my_ain[2] = ain2;
    assign my_ain[3] = ain3;
    assign my_bin[0] = bin0;
    assign my_bin[1] = bin1;
    assign my_bin[2] = bin2;
    assign my_bin[3] = bin3;
    
    // assign dout0 = cmd == 4 ? my_dout[0] : (cmd == 0 ? my_dout[0] : 0);
    assign dout0 = cmd == 4 ? my_dout[0] : (cmd == 0 ? my_dout[0] : 0);
    assign dout1 = cmd == 4 ? my_dout[1] : (cmd == 1 ? my_dout[1] : 0);
    assign dout2 = cmd == 4 ? my_dout[2] : (cmd == 2 ? my_dout[2] : 0);
    assign dout3 = cmd == 4 ? my_dout[3] : (cmd == 3 ? my_dout[3] : 0);

    
//    assign my_ain = {ain0, ain1, ain2, ain3};
    
    genvar i;
    generate for (i = 0; i < 4; i = i + 1) begin: adder
        adder a(my_ain[i], my_bin[i], my_dout[i], overflow[i]);
    end endgenerate
    
endmodule