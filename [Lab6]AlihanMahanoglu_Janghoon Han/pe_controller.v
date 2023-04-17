`timescale 1ns / 1ps

module pe_con#(
    parameter VECTOR_SIZE = 16, // vector size
    parameter L_RAM_SIZE = 4
  )(
    input start,
    output done,
    input aclk,
    input aresetn,
    output [L_RAM_SIZE:0] rdaddr,	// address from PE
    input [31:0] rddata,
    output reg [31:0] wrdata
  );

    // PE
    wire [31:0] ain;
    wire [31:0] din;
    wire [L_RAM_SIZE-1:0] addr;
    wire we_local;	// we for local reg in PE
    wire we_global;	// we for global reg on the outside of PE
    wire valid;		// input valid
    wire dvalid;
    wire [31:0] dout;
    wire [L_RAM_SIZE-1:0] rdaddr;	// address from PE
   
    // global block ram
    reg [31:0] gdout;
    (* ram_style = "block" *) reg [31:0] globalmem [0:VECTOR_SIZE-1];
    always @(posedge aclk)
        if (we_global) globalmem[rdaddr] <= rddata[rdaddr];
        else gdout <= globalmem[rdaddr];
		
    // down counter
    reg [31:0] counter;
    wire [31:0] ld_val = CNTDONE;
    wire counter_ld = valid;
    wire counter_en = 1'b1;
    wire counter_reset = load_done | calc_done | done_done;
    always @(posedge aclk)
        if (counter_reset) counter <= 'd0;
        else
            if (counter_ld) counter <= ld_val;
            else if (counter_en) counter <= counter - 1;
   
    // FSM
    // transition triggering flags
    wire load_done;
    wire calc_done;
    wire done_done;
        
    // state register
    reg [3:0] state, state_d;
    localparam S_IDLE = 4'd0;
    localparam S_LOAD = 4'd1;
    localparam S_CALC = 4'd2;
    localparam S_DONE = 4'd3;

    // part 1: state transition
    always @(posedge aclk)
        if (!aresetn)
            state <= S_IDLE;
        else
            case (state)
                S_IDLE:
                    if(start) state <= S_LOAD;
                    else state <= state_d;
                S_LOAD: // LOAD PERAM
                    if(load_done) state <= S_CALC;
                    else state <= state_d;  
                S_CALC: // CALCULATE RESULT
                    if(calc_done) state <= S_DONE; 
                    else state <= state_d;
                S_DONE:
                    if(done_done) state <= S_IDLE;
                    else state <= state_d;
               default:
                    state <= S_IDLE;
           endcase
    
    always @(posedge aclk)
        if (!aresetn) state_d <= S_IDLE;
        else state_d <= state;

    // part 2: determine state
    // S_LOAD
    reg load_flag;
    wire load_flag_reset = start;
    wire load_flag_en = counter_en;
    localparam CNTLOAD1 = VECTOR_SIZE;
    always @(posedge aclk)
        if (load_flag_reset) load_flag <= 'd0;
       else
           if (load_flag_en) load_flag <= 'd1;
           else load_flag <= load_flag;
    
    // S_CALC
    reg calc_flag;
    wire calc_flag_reset = load_done;
    wire calc_flag_en = counter_en;
    localparam CNTCALC1 = VECTOR_SIZE;
    always @(posedge aclk)
        if (calc_flag_reset) calc_flag <= 'd0;
        else
            if (calc_flag_en) calc_flag <= 'd1;
            else calc_flag <= calc_flag;
    
    // S_DONE
    reg done_flag;
    wire done_flag_reset = calc_done;
    wire done_flag_en = counter_en;
    localparam CNTDONE = 5;
    always @(posedge aclk)
        if (done_flag_reset) done_flag <= 'd0;
        else
            if (done_flag_en) done_flag <= 'd1;
            else done_flag <= done_flag;
    
    // part3: update output and internal register
    // S_LOAD: we
    assign we_local = ~we_global  ? 'd1 : 'd0;
    assign we_global = ~we_local  ? 'd1 : 'd0;
	
    // S_CALC: wrdata
    always @(posedge aclk)
        if (!aresetn) wrdata <= 'd0;
        else
            if (calc_done) wrdata <= dout;
            else wrdata <= wrdata;

	// S_CALC: valid
    reg valid_pre, valid_reg;
    always @(posedge aclk)
        if (!aresetn) valid_pre <= 'd0;
        else
           if (calc_done) valid_pre <= 'd1;
           else valid_pre <= 'd0;
    
    always @(posedge aclk)
        if (!aresetn) valid_reg <= 'd0;
        else if (calc_flag) valid_reg <= valid_pre;
     
    assign valid = valid_reg;
    
	// S_CALC: ain
	assign ain = ~we_global ? gdout : 'd0;

	// S_LOAD&&CALC
    assign addr = ~we_global ? addr : 'd0;
	
	// S_LOAD
    assign din = we_local ? rddata : 'd0;
    assign rdaddr = ~we_local ? addr : 'd0;

	// done signals
    assign load_done = (load_flag) && (counter == 'd0);
    assign calc_done = (calc_flag) && (counter == 'd0) && dvalid;
    assign done_done = (done_flag) && (counter == 'd0);
    assign done = (state == S_DONE) && done_done;
    
    my_pe #(.L_RAM_SIZE(L_RAM_SIZE)) PE (
        .aclk(aclk),
        .aresetn(aresetn && (state != S_DONE)),
        .ain(ain),
        .din(din),
        .addr(addr),
        .we(we_local),
        .valid(valid),
        .dvalid(dvalid),
        .dout(dout)
    );
endmodule