`timescale 1ns / 1ps

module layer_mapping_tb;
reg [31:0] complex_numbers [0:15];  // Array to store 16 complex numbers
reg [0:255] codeword0;// Array containing 8 modulation symbols
reg [0:255] codeword1;// Array containing 8 modulation symbols
reg clk;

// Outputs
// 8 layers with 2 modulation symbols (64) each
wire [0:63] layer1;
wire [0:63] layer2;
wire [0:63] layer3;
wire [0:63] layer4;
wire [0:63] layer5;
wire [0:63] layer6;
wire [0:63] layer7;
wire [0:63] layer8;

// Instantiate the layer_mapping module
layer_mapping dut (
    .clk(clk),
    .codeword0(codeword0),
    .codeword1(codeword1),
    .layer1(layer1),
    .layer2(layer2),
    .layer3(layer3),
    .layer4(layer4),
    .layer5(layer5),
    .layer6(layer6),
    .layer7(layer7),
    .layer8(layer8)    
);

   // Clock generation
    initial begin
    clk = 0;
    forever #5 clk = ~clk;
     end
     
    integer file, scan_result, i;
    integer end_of_file = 0;
    initial begin
        // Open file for reading
        file = $fopen("F:/IIT/FPGA/Modulation/complex_numbers.dat", "r");
        if (file == 0) begin
            $display("Error: failed to open file.");
            $finish;
        end
    end
    
    always @(posedge clk) begin
        if (!end_of_file) begin
            for (i = 0; i < 16; i = i + 1) begin
                scan_result = $fscanf(file, "%b\n", complex_numbers[i]);
                if (scan_result != 1) begin
                    end_of_file = 1;  // Set flag if end of file is reached or error occurs
                     $finish;
                end
            end
            codeword0 = {complex_numbers[0], complex_numbers[1], complex_numbers[2], complex_numbers[3],complex_numbers[4],complex_numbers[5],complex_numbers[6],complex_numbers[7]};
            codeword1 = {complex_numbers[8], complex_numbers[9], complex_numbers[10], complex_numbers[11],complex_numbers[12],complex_numbers[13],complex_numbers[14],complex_numbers[15]};
                $display("codewords:");
                $display("codeword0 = %b",  codeword0);
                $display("codeword1 = %b",  codeword1);
//                $display("Layer mappings:");
//                $display("layer1 = %b",  layer1);
//                $display("layer2 = %b",  layer2);
//                $display("layer3 = %b",  layer3);
//                $display("layer4 = %b",  layer4);
//                $display("layer5 = %b",  layer5);
//                $display("layer6 = %b",  layer6);
//                $display("layer7 = %b",  layer7);
//                $display("layer8 = %b",  layer8);
                   
        end
    end

    // End simulation after a delay to allow for file processing
    initial begin
        #1000;
        $fclose(file);
        $finish;
    end
endmodule
