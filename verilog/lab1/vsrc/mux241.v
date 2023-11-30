module mux241(x, s, f);
  input  [1:0] x[0:3];
  input  [1:0] s;
  output [1:0] f;
  MuxKeyWithDefault #(4, 2, 2) i0 (f, s, 2'b00, {
    2'b00, x[0],
    2'b01, x[1],
    2'b10, x[2],
    2'b11, x[3]
  });
endmodule
