module Register(
    input clk,
    input reset,
    input enable,
    input write,
    input[7:0] in,
    output wire[7:0] out
);

    reg[7:0] a;

    initial begin
        a = 0;
    end

    assign out = (enable) ? a : 8'bz;

    always @ (posedge reset) begin
        a = 0;
    end

    always @ (posedge clk) begin
        case (write)
            1: a <= in;
            default: ;
        endcase
    end

endmodule



module Register_tb(
);

reg clk,reset, enable, write;
reg [7:0] in;
wire [7:0] out;
Register a(clk,reset, enable, write, in, out);


initial begin
    clk = 0;
    reset = 0;
    enable = 0;
    write = 0;

    $display("clk,\treset,\tenable,\twrite,\tin,\tout"); 
    $monitor("%b,\t%b,\t%b,\t%b,\t%b,\t%b", clk,reset,enable,write,in,out);

    #1  clk=0;
    #2  clk=1;
    #3  clk=0;
    #4  clk=1;enable=1;
    #5  clk=0;
    #6  clk=1;enable=0;
    #7  clk=0;
    #8  clk=1;write=1;in=255;
    #9  clk=0;
    #10  clk=1;write=0;in=11;enable=1;
    #11  reset=1;

end



endmodule
