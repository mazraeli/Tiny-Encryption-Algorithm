module enc_tb();
  reg clk, rst, start;
  reg [32 - 1 : 0] vi0, vi1;
  wire ready;
  wire [32 - 1 : 0] vo0, vo1;

  encrypt dut(clk, rst, vi0, vi1, start, ready, vo0, vo1);

  initial begin
    rst = 1; #10;
    vi0 = 32'hffffffff; vi1 = 32'hffffffff; #10;
    rst = 0; #10;
    start = 1;
    end

  always  begin
    clk = 1; #5; clk = 0; #5;
  end
endmodule
