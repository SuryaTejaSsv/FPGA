`timescale 1ns / 1ps

module modulation(
    input clk,          // Clock input
    input rst,          // Reset input
    input x,            // Input x
    input tvalid,
    output reg signed [15:0] real_part, // Output real part (Q15.16 format)
    output reg signed [15:0] imag_part  // Output imaginary part (Q15.16 format)
    
);

reg  position;    // Counter to track position (starts from 0)

always @(posedge clk or posedge rst) begin
    if (rst) begin
        position <= 1'b1;
         real_part <= 16'd0; // Initialize real part to 0
        imag_part <= 16'd0; // Initialize imaginary part to 0
    end
    else if(tvalid) begin
      // Increment position on each valid data
       position = position + 1;
        // Determine output based on input x and position
        if (x == 1'b1) begin
            if (position == 1'b0) begin // If position is even
                real_part <= 16'd23171; // Real part = 1/sqrt(2) in Q15.16 format
                imag_part <= 16'd23171; // Imaginary part = 1/sqrt(2) in Q15.16 format
            end
            else begin // If position is odd
                real_part <= -16'd23171; // Real part = -1/sqrt(2) in Q15.16 format
                imag_part <= 16'd23171;  // Imaginary part = 1/sqrt(2) in Q15.16 format
            end
        end
        else begin // If input x is 0
            if (position == 1'b0) begin // If position is even
                real_part <= -16'd23171; // Real part = -1/sqrt(2) in Q15.16 format
                imag_part <= -16'd23171; // Imaginary part = -1/sqrt(2) in Q15.16 format
            end
            else begin // If position is odd
                real_part <= 16'd23171; // Real part = 1/sqrt(2) in Q15.16 format
                imag_part <= -16'd23171; // Imaginary part = -1/sqrt(2) in Q15.16 format
            end
        end    
    end
end

endmodule

