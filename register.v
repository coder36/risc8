module Register(
    input clk,
    input enable,
    input write,
    input[7:0] in,
    output wire[7:0] out
);

    reg[7:0] a;

    assign out = (enable) ? a : 1'bz;

    always @ (posedge clk) begin
        case (write)
            1: a <= in;
            default: ;
        endcase
    end

endmodule

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

    assign out = (enable) ? a : 1'bz;
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

    assign out = (enable) ? resultBuffer : 1'bz;

endmodule


module StepCounter(
    input clk,
    input reset,
    output[3:0] i
);
    reg counter;
    
    initial begin
        counter=0;
    end

    always @ (posedge clk) begin
        counter = counter + 1;
        if( reset == 1 ) begin
            counter = 0;
        end
    end

    assign i = counter;

endmodule


module Bus(
    input clk
);

    wire[7:0] bus;

    wire regAEnable;
    wire regAWrite;
    Register regA( clk, regAEnable, regAWrite, bus, bus);

    wire regBEnable;
    wire regBWrite;
    Register regB( clk, regBEnable, regBWrite, bus, bus);

    wire counterReset;
    wire [3:0]  steppedClk;
    StepCounter counter(clk, counterReset, steppedClk);

    initial begin
        assign regAEnable=0;
        // regAWrite=0;
        // regBEnable=0;
        // regBWrite=0;
        // counterReset=0;
    end



endmodule