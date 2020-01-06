module Stepper(
    input clk,
    input reset,
    output[2:0] i
);
    reg [2:0] counter;
    
    initial begin
        counter=0;
    end

    always @ (posedge clk ) begin
        counter = counter + 1;
    end

    always @ (posedge reset) begin        
        counter = 0;        
    end

    assign i = counter;

endmodule


// test bench
// `timescale 1ns/1ns //Adjust to suit
module Stepper_tb(
);
    reg clk;
    reg reset;
    wire [2:0] i;

    Stepper stepper(
        clk,
        reset,
        i
    );

        
    // always #10 clk = ~clk;
    


    initial begin
        clk = 0;
        reset = 0;        

        $display("clk,\treset,\ti"); 
        $monitor("%b,\t%b,\t%b", clk,reset,i);

     #1   clk = 0;
     #2   clk = 1;
     #3   clk = 0;
     #4   clk = 1;
     #5   clk = 0;
     #6   clk = 1; reset=1;
     #7   clk = 0;
     #8   clk = 1; reset=0;
     #9   clk = 0;
     #10   clk = 1;
     #11   clk = 0;
     #12   clk = 1;

    $finish;
    //  #100  ; 

    end

    

endmodule