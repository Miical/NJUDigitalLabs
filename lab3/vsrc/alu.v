module alu(
  input signed [3:0] a,
  input signed [3:0] b,
  input [2:0] op,
  output reg signed [3:0] out,
  output reg overflow,
  output reg carry,
  output reg zero
);

reg [3:0] t_add_Cin;

always @(*) begin
  out = 4'b0000;
  overflow = 1'b0;
  carry = 1'b0;
  zero = 1'b0;
  t_add_Cin = 4'b0000;

  if (op[2:1] == 2'b000) begin
    t_add_Cin =( {4{op[0]}}^b )+ {3'b000, op[0]};
    { carry, out } = a + t_add_Cin;
    overflow = (a[3] == t_add_Cin[3]) && (out[3] != a[3]);
  end else if (op == 3'b010) begin
    out = ~a;
  end else if (op == 3'b011) begin
    out = a & b;
  end else if (op == 3'b100) begin
    out = a | b;
  end else if (op == 3'b101) begin
    out = a ^ b;
  end else if (op == 3'b110) begin
    out = a < b ? 4'b0001 : 4'b0000;
  end else if (op == 3'b111) begin
    out = a == b ? 4'b0001 : 4'b0000;
  end

  if (out == 4'b0000) begin
    zero = 1'b1;
  end else begin
    zero = 1'b0;
  end

end

endmodule
