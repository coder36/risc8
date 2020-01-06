`define ALU_ADD 3'b000
`define ALU_SUB 3'b001
`define ALU_INC 3'b010
`define ALU_DEC 3'b011
`define ALU_AND 3'b100
`define ALU_OR  3'b101
`define ALU_XOR 3'b110
`define ALU_ADC 3'b111

module Alu(
    input clk,
    input[2:0] opcode,
    input[7:0] a,
    input[7:0] b,
    input enable,
    output [7:0] out,
    output reg carry,
    output reg z
);
    reg [7:0] resultBuffer; 
    reg carryBuffer; 

    always @(posedge clk) begin
        if( enable ) begin
            case (opcode)
                `ALU_ADD: {carry, resultBuffer} = a + b;
                `ALU_ADC: {carry, resultBuffer} = a + b + carry;
                `ALU_SUB: {carry, resultBuffer} = a - b;
                `ALU_INC: {carry, resultBuffer} = a+1;
                `ALU_DEC: {carry, resultBuffer} = a-1;
                `ALU_AND: {carry, resultBuffer} = a&b;
                `ALU_OR: {carry, resultBuffer} = a|b;
                `ALU_XOR: {carry, resultBuffer} = a^b;
                default: resultBuffer = 'hxx;
            endcase
            z = (resultBuffer == 0) ? 1 : 0;
        end
    end

    assign out = (enable) ? resultBuffer : 8'bz;

endmodule


// test bench
module Alu_tb(    
);

    reg clk;
    reg [2:0] opcode;
    reg [7:0] a;
    reg [7:0] b;
    reg enable;
    wire carry;
    wire [7:0] out;
    wire z;

    Alu alu(clk, opcode, a, b, enable, out, carry, z);
    initial begin 
        $display("clk,\topcode,\ta,\t\tb,\t\tenable,\tout,\t\tcarry,\tz"); 
        $monitor("%b,\t%b,\t%b,\t%b,\t%b,\t%b,\t%b,\t%b", clk, opcode, a, b, enable, out, carry, z);

        #1  clk = 0; a=0; b=0;
        #2  clk = 1; a = 5; b=6; opcode=`ALU_ADD; enable=1;
        #3  clk = 0;
        #4  clk = 1; enable=0;
        #5  clk = 0;
        #6  clk = 1; a = 0; b=0; opcode=`ALU_ADD; enable=1;
        #7  clk = 0;
        #8  clk = 1; a = 255; b=1; opcode=`ALU_ADD; enable=1;
        #9  clk = 0;
        #10 clk = 1;

    end


endmodule