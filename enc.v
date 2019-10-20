//
// Tiny Encryption Algorithm
// Here is encryption module
//
// *
//  You must set DATA_WIDTH and COUNTER_WIDTH manually
// *
module encrypt(clk, rst, vi0, vi1, start, ready, vo0, vo1);
// parameters
parameter DATA_WIDTH = 32;
parameter COUNTER_WIDTH = 5 + 1; // 2^5 = 32 (it depends on DATA_WIDTH)

// input & output declarations
input clk, rst, start;
input [DATA_WIDTH - 1 : 0] vi0, vi1;
output reg ready;
output reg [DATA_WIDTH - 1 : 0] vo0, vo1;

// internal signals
reg [2 : 0] state, next_state;
reg [DATA_WIDTH - 1 : 0] sum, key;
reg [COUNTER_WIDTH - 1 : 0] counter;
wire [DATA_WIDTH - 1 : 0] vi0_right_shifted, vi0_left_shifted, vi0_1, v1_res,
                          vi1_right_shifted, vi1_left_shifted, vi1_1, v0_res;

// declarations of states' names
localparam [2 : 0]
  IDLE = 3'b000,
  KEY_ACC = 3'b001,
  V0_CALC = 3'b010,
  V1_CALC = 3'b011,
  FINAL = 3'b100;

// sequential logic
always @ ( posedge clk ) begin
  key <= 32'h9e3779b9;
  if (rst) begin
    state <= IDLE;
  end
  else begin
    state <= next_state;
  end
end

//combinational logic
always @ ( vi0, vi1, start, state ) begin
  counter <= counter;
  case (state)
    IDLE: begin
      sum <= 0;
      vo0 <= vi0;
      vo1 <= vi1;
      ready <= 0;
      counter <= 0;
      if (start) begin
        next_state <= KEY_ACC;
      end
      else begin
        next_state <= IDLE;
      end
    end
    KEY_ACC: begin
      sum <= sum + key;
      vo0 <= vo0;
      vo1 <= vo1;
      ready <= 0;
      next_state <= V0_CALC;
    end
    V0_CALC: begin
      sum <= sum;
      vo0 <= vo0 + v0_res;
      vo1 <= vo1;
      ready <= 0;
      next_state <= V1_CALC;
    end
    V1_CALC: begin
      sum <= sum;
      vo0 <= vo0;
      vo1 <= vo1 + v1_res;
      ready <= 0;
      if (counter == 31) begin
        next_state <= FINAL;
      end
      else begin
        next_state <= KEY_ACC;
        counter <= counter + 1;
      end
    end
    FINAL: begin
      sum <= sum;
      vo0 <= vo0;
      vo1 <= vo1;
      ready <= 1;
      next_state <= IDLE;
    end
    default: begin
      sum <= sum;
      vo0 <= vo0;
      vo1 <= vo1;
      ready <= 0;
      next_state <= IDLE;
    end
  endcase
end

// logic assignments
assign vi0_right_shifted = vo0 >> 5;
assign vi0_left_shifted = vo0 << 4;
assign vi0_1 = vo0 + sum;
assign v1_res = vi0_left_shifted ^ vi0_1 ^ vi0_right_shifted;

assign vi1_right_shifted = vo1 >> 5;
assign vi1_left_shifted = vo1 << 4;
assign vi1_1 = vo1 + sum;
assign v0_res = vi1_left_shifted ^ vi1_1 ^ vi1_right_shifted;

endmodule
