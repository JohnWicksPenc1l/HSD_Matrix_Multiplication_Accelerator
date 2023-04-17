`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2019 10:02:39 PM
// Design Name: 
// Module Name: tb_adder_array
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


module tb_adder_array();
    reg [2:0] cmd;
    reg [31:0] ain0, ain1, ain2, ain3;
    reg [31:0] bin0, bin1, bin2, bin3;
    
    wire [31:0] dout0, dout1, dout2, dout3;
    wire [3:0] overflow;

integer i;
    
    initial begin
        cmd <= 0;
        for(i = 0; i < 32; i = i+1) begin
            ain0 = $urandom%(2**31);
            ain1 = $urandom%(2**31);
            ain2 = $urandom%(2**31);
            ain3 = $urandom%(2**31);
            bin0 = $urandom%(2**31);
            bin1 = $urandom%(2**31);
            bin2 = $urandom%(2**31);
            bin3 = $urandom%(2**31);
            #20;
        end
     end
    
    always #20 begin
        repeat (4) begin
            cmd = cmd + 1;
            #20;
        end
        cmd = 0;
    end
    
    adder_array UUT(
        .cmd(cmd),
        .ain0(ain0), .ain1(ain1), .ain2(ain2), .ain3(ain3),
        .bin0(bin0), .bin1(bin1), .bin2(bin2), .bin3(bin3),
        .dout0(dout0), .dout1(dout1), .dout2(dout2), .dout3(dout3),
        .overflow(overflow)
    );

endmodule