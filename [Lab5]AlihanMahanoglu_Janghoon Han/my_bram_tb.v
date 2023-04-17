`timescale 1ns / 1ps

module my_bram_tb();


reg [14:0] BRAM_ADDR1,BRAM_ADDR2;
reg BRAM_CLK1,BRAM_CLK2;
wire [31:0] BRAM_WRDATA1,BRAM_WRDATA2;
wire [31:0] BRAM_RDDATA1,BRAM_RDDATA2;
reg BRAM_EN1,BRAM_EN2;
reg BRAM_RST1,BRAM_RST2;
reg [3:0] BRAM_WE1,BRAM_WE2;
wire done1,done2;

always #10 BRAM_CLK1 = ~BRAM_CLK1;
always #10 BRAM_CLK2 = ~BRAM_CLK2;

assign BRAM_WRDATA2 = BRAM_RDDATA1;
integer i;

initial begin


BRAM_CLK1 = 0;
BRAM_CLK2 = 0;
BRAM_RST1 = 0;
BRAM_RST2 = 0;
BRAM_WE1 = 4'b0000;
BRAM_WE2 = 4'b1111;
BRAM_EN1 = 1;
BRAM_EN2 = 1;

    #10;

 
 for(i = 0; i < 8192; i = i+4) begin
    BRAM_ADDR1 = i;
    #20;
    BRAM_ADDR2 = i;
    
end
 

end


my_bram #(15,"input.txt","") UUT1(            

.BRAM_ADDR(BRAM_ADDR1),
.BRAM_CLK(BRAM_CLK1),
.BRAM_WRDATA(BRAM_WRDATA1),
.BRAM_WE(BRAM_WE1),
.BRAM_RST(BRAM_RST1),
.BRAM_RDDATA(BRAM_RDDATA1),
.BRAM_EN(BRAM_EN1),
.done(done1)
);

my_bram #(15,"","/csehome/amahanoglu15/Downloads/output.txt") UUT2(

.BRAM_ADDR(BRAM_ADDR2),
.BRAM_CLK(BRAM_CLK2),
.BRAM_WRDATA(BRAM_WRDATA2),
.BRAM_WE(BRAM_WE2),
.BRAM_RST(BRAM_RST2),
.BRAM_RDDATA(BRAM_RDDATA2),
.BRAM_EN(BRAM_EN2),
.done(done2)
);

endmodule
