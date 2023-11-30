module lfsr(
  input clk,
  input rst,
  output [7:0] out,
  output [6:0] seg0,
  output [6:0] seg1
);
  reg [7:0] state;

  bcd7seg sega(
    .b(state[3:0]),
    .h(seg0)
  );

  bcd7seg segb(
    .b(state[7:4]),
    .h(seg1)
  );

  initial begin
    state = 8'b00000001;
  end

  always @(posedge clk or posedge rst) begin
    if (rst) begin
      state <= 8'b00000001;
    end else begin
      state <= {state[4] ^ state[3] ^ state[2] ^ state[0], state[7:1]};
    end
  end

  assign out = state;

endmodule
