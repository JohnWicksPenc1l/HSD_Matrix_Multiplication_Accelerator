`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/27/2019 08:17:28 PM
// Design Name: 
// Module Name: tb_int
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


module tb_int();

    reg [32-1:0] A;
    reg [32-1:0] B;
    reg [32-1:0] C;
    reg SUBTRACT;
    
    wire [32-1:0] P;
    wire [47:0] PCOUT;
    
    integer i;
    
    initial begin
        SUBTRACT <= 0;
        for(i = 0; i < 32; i = i+1) begin
            A= i;
            B= i+1;
            C= i+2;
            /*A = $urandom%(2**31);
            B = $urandom%(2**31);
            C = $urandom%(2**31);*/
            #20;
        end
     end
    
    xbip_multadd_0 UUT(
        .A(A),
        .B(B),
        .C(C),
        .SUBTRACT(SUBTRACT),
        .P(P),
        .PCOUT(PCOUT)
    );
    
   endmodule