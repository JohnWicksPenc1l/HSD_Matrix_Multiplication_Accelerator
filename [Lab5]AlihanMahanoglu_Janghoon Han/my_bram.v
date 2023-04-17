`timescale 1ns / 1ps

module my_bram # (
parameter integer BRAM_ADDR_WIDTH = 15, // 4x8192
parameter INIT_FILE = "",      //"/csehome/amahanoglu15/Downloads/input.txt"
parameter OUT_FILE = "output.txt"
)(
input wire [BRAM_ADDR_WIDTH-1:0] BRAM_ADDR,
input wire BRAM_CLK,
input wire [31:0] BRAM_WRDATA,
output reg [31:0] BRAM_RDDATA,
input wire BRAM_EN,
input wire BRAM_RST,
input wire [3:0] BRAM_WE,
input wire done
);

reg [31:0] mem[0:8191];
wire [BRAM_ADDR_WIDTH-3:0] addr = BRAM_ADDR[BRAM_ADDR_WIDTH-1:2];  
integer counter;
integer i;

//codes for simulation
initial begin
counter = 1;
    if (INIT_FILE != "") 
    $readmemh(INIT_FILE , mem, 0, 8191) ;    //read data from INIT_FILE and store them into mem
wait (done) $writememh(OUT_FILE, mem);          //write data stored in mem into OUT_FILE

end

//code for BRAM implementation



always@(posedge BRAM_CLK or posedge BRAM_RST) begin

if(BRAM_EN)begin
    if(BRAM_RST) BRAM_RDDATA= 0;
    else begin
        if(BRAM_WE== 4'b0) begin
            if(counter ==1) BRAM_RDDATA = mem[addr];
        counter = ~counter;
        end
        else begin
        for (i = 0; i <4; i = i+1) begin
                if (BRAM_WE[i])  mem[addr][i*8+:8] = BRAM_WRDATA[i*8+:8]; //data input
        end 
    end
end

//BRAM_RDDATA <= (BRAM_RST == 1) ? 0: 
//                     (BRAM_WE== 4'b0 && BRAM_EN == 1 && counter == 1) ? mem[addr] : BRAM_RDDATA;
                                        
//if(BRAM_WE== 4'b0 && BRAM_EN == 1) counter = ~counter;

//    if (BRAM_EN)begin
//            for (i = 0; i <4; i = i+1) begin
//                if (BRAM_WE[i])  mem[addr][i*8+:8] = BRAM_WRDATA[i*8+:8]; //data input
//            end
//    end
//end



endmodule
