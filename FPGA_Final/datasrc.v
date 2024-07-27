
//////////////////////////////////////////////////////////////////////////////////
// Read input pattern from a file and give it out as an AXI stream
//////////////////////////////////////////////////////////////////////////////////

module datasrc #(parameter xL=65)(
    input clk,
    input resetn,
    input tready,
    output tvalid,
    output  tdata
    );
    
    localparam infile = "F:/IIT/FPGA/Modulation/inp_bin.dat";
    
    reg [31:0] mem[0:xL-1];
    localparam S0 = 'd0;
    localparam S1 = 'd1;
    localparam S2 = 'd2;
    localparam S3 = 'd3;
    localparam S4 = 'd4;
    
    reg [2:0] state, n_state;
    reg [10:0] addr, n_addr;
    reg [31:0] d0, d1, d2, n_d1, n_d2;
    reg valid, n_valid;
    
    initial $readmemb(infile, mem);

    assign tvalid = valid;
    assign tdata = n_d2;
        
    always @(posedge clk) begin
        if (~resetn) begin
            state <= S0;
            addr <= 'd0;
            d0 <= 'd0;
            d1 <= 'd0;
            d2 <= 'd0;
            valid <= 0;
        end else begin
            state <= n_state;
            addr <= n_addr;
            d0 <= mem[n_addr];
            d1 <= n_d1;
            d2 <= n_d2;
            valid <= (addr < xL) && n_valid;
        end
    end
    
    always @(*) begin
        // Defaults
        n_d1 = d1;
        n_d2 = d2;
        n_state = state;
        n_addr = addr;
        n_valid = valid;
        // Conditional:
        case (state)
            S0: begin
                n_addr = 'd0;
                n_state = S1;
                n_valid = 0;
            end
            S1: begin
                n_d1 = d0;
                n_addr = 'd1;
                n_state = S2;
                n_valid = 1;
            end
            S2: begin
                n_d1 = d0;
                n_d2 = d1;
                n_valid = 1;
                if (tready) begin
                    n_addr = addr + 1;  
                    n_state = S2;
                end else begin
                    n_state = S3;
                end
            end
            S3: begin
                if (tready) begin
                    n_addr = addr + 1;
                    n_state = S2;
                end else begin
                    n_state = S3;
                end
            end
            
            default: begin
                n_state = S0;
            end
        endcase
    end
    
endmodule
