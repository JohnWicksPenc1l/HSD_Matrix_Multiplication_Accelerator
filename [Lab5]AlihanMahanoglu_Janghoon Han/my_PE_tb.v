`timescale 1ns / 1ps

module my_PE_tb();

        reg aclk;
        reg aresetn;
        reg [31:0] ain;
        reg [31:0] din;
        reg [5:0]  addr;
        reg we;
        reg valid;
        wire dvalid;
        wire [31:0] dout;
        
        reg [31:0] memo[0:15];
        reg [31:0] memo2[0:15];
        
always #2 aclk = ~aclk;

integer i,k;

initial  begin

aclk = 0;
aresetn = 1;           //negative clock: resets when ==0
we = 1;                // write enable signal when ==1 din is stored into peram[addr], when ==0 peram[addr] is assigned to one of inputs of MAC.
valid = 0;             //MAC is not ready to start calculation yet

$readmemh("ain.txt" , memo);
$readmemh("din.txt" , memo2);

//Make testbench that first stores 16 data into local register with 16
//consecutive addresses, from address 0 to address 15.

    for (i = 0; i <16; i = i+1) begin
        #4;
        addr = i;                          // din will be stored into peram[addr] when we ==1
        din = memo2[i];     
    end
    #4;
    
//Then, PE gets 16 new data from outside serially to perform MAC
//operations with the data stored in local register.

we = 0;
valid = 1; 

    for (k = 0; k <16; k = k+1) begin
    wait (valid == 1) begin
        ain = memo[k];
        addr = k;
        //if (k>8) aresetn = 0;         //Test for aresetn signal
        #4;
        valid = 0;
        @(posedge dvalid) #4;
        end
    end
   
end

always @*
begin
wait (dvalid ==1)
#4 valid = 1;
end

my_PE #(6) UUT1(            

.aclk(aclk),
.aresetn(aresetn),
.ain(ain),
.din(din),
.addr(addr),
.we(we),
.valid(valid),
.dvalid(dvalid),
.dout(dout)
);

endmodule
