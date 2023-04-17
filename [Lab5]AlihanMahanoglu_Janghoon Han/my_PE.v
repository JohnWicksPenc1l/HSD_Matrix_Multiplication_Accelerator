`timescale 1ns / 1ps

module my_PE #(
        parameter L_RAM_SIZE = 6
    )
    (
        // clk/reset
        input aclk,
        input aresetn,
        // port A
        input [31:0] ain,
        // peram -> port B 
        input [31:0] din,
        input [L_RAM_SIZE-1:0]  addr,
        input we,
        // integrated valid signal
        input valid,
        // computation result
        output dvalid,
        output [31:0] dout
    );

   (* ram_style = "block" *) reg [31:0] peram [0:2**L_RAM_SIZE - 1];  // local register
   
   reg [31:0] tempSum = 0;
   reg [31:0] memin;
   wire [31:0] ddout;
   
//always@(posedge dvalid)begin
//tempSum = ddout;
//end 

always@(posedge aclk) begin
tempSum = ddout;

if(we == 1) peram[addr] = din;
else memin=peram[addr];

end


     floating_point_0 MAC(
        .aclk(aclk),
        .aresetn(aresetn),
        .s_axis_a_tvalid(valid),
        .s_axis_b_tvalid(valid),
        .s_axis_c_tvalid(valid),
        .s_axis_a_tdata(ain),
        .s_axis_b_tdata(memin), 
        .s_axis_c_tdata(tempSum),
        .m_axis_result_tvalid(dvalid),
        .m_axis_result_tdata(ddout)
    );
      
assign dout = (aresetn == 0 || dvalid == 0) ? 0: ddout;

endmodule  
