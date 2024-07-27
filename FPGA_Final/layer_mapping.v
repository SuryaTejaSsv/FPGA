`timescale 1ns / 1ps


module layer_mapping(
input clk,
input  [0:255] codeword0 ,
input [0:255] codeword1, // 2 codewords with 8 modulation symbols each
output reg [0:63] layer1,
output reg [0:63] layer2,
output reg [0:63] layer3,
output reg [0:63] layer4,
output reg [0:63] layer5,
output reg [0:63] layer6,
output reg [0:63] layer7,
output reg [0:63] layer8 // 8 layers with 2 modulation symbols each
);

always @(posedge clk) begin
    layer1[0:63] <= {codeword0[0:31],codeword0[128:159]};
    layer2[0:63] <=  {codeword0[32:63],codeword0[160:191]};
    layer3[0:63] <= {codeword0[64:95],codeword0[192:223]};
    layer4[0:63] <= {codeword0[96:127],codeword0[224:255]};
    
    layer5[0:63] <= {codeword1[0:31],codeword1[128:159]};
    layer6[0:63] <=  {codeword1[32:63],codeword1[160:191]};
    layer7[0:63] <= {codeword1[64:95],codeword1[192:223]};
    layer8[0:63] <= {codeword1[96:127],codeword1[224:255]};       
end

endmodule
