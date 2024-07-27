`timescale 1ns / 1ps

module modulation_tb;

    reg clk;
    reg rst;
    reg tready;
    wire tvalid;
    wire tdata;
   
    reg x;
    wire signed [15:0] real_part;
    wire signed [15:0] imag_part;
    reg [31:0] complexnumber;
    
// Instantiate the datasrc module
    datasrc #(.xL(65)) src (
        .clk(clk),
        .resetn(~rst), // Active-low reset
        .tready(tready), // Ready to accept data
        .tvalid(tvalid), // Data valid signal
        .tdata(tdata)    // Data output
    );
    
    // Instantiate the DUT
    modulation dut (
        .clk(clk),
        .rst(rst),
        .x(x),
        .tvalid(tvalid),
        .real_part(real_part),
        .imag_part(imag_part)        
    );


    // Clock generation
    initial begin
    clk = 1;
    forever #5 clk = ~clk;
    end
     
    // Reset generation
    initial begin
        rst = 1;
        #10 rst = 0;
    end
    
    // Ready signal handling
    initial begin
        tready = 0;  // Start with tready low
        #20 tready = 1;  // Set tready high after some initial delay
    end
    
    // File descriptor
    integer file;
    initial begin
        // Open a file for writing
        file = $fopen("F:/IIT/FPGA/Modulation/complex_numbers.dat", "w");
        // Check if the file was opened successfully
        if (file == 0) begin
            $display("Error: failed to open file.");
            $finish;
        end
    end
    
    // Stimulus
    always @(posedge clk) begin   
        if (tvalid) begin
            x = tdata; // input x           
            if(dut.real_part !=0) begin //To display and store
                 // Combine the real and imaginary parts
                complexnumber = {real_part, imag_part}; // Concatenate real and imaginary parts
                // Write to file
                $fwrite(file, "%b\n", complexnumber);
                //display
                $display("same tvalid=%d ,Input x = %b, Position = %d :", tvalid,dut.x, dut.position);
                $display("same Real part = %d, Imaginary part = %d", real_part, imag_part);
        end     
       end
    end
    
    
     // End simulation
    initial begin
	
        #1000 $fclose(file); $finish;  // Stop the simulation after a certain time
    end
    
endmodule
