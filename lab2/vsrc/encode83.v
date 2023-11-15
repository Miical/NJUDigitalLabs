module encode83(
    input [7:0] x,
    output [6:0] seg,
    output [2:0] y,
    output valid
);
    reg [3:0] i;
    reg [3:0] ty;
    bcd7seg seg0(.b(ty), .h(seg));

    always @(*) begin
        ty = 0;
        for (i = 0; i < 4'd8; i = i + 1) begin
            if (x[i[2:0]] == 1'b1) begin
                ty = i;
            end
        end
    end

    assign valid = x[0] | x[1] | x[2] | x[3] | x[4] | x[5] | x[6] | x[7];
    assign y = ty[2:0];
endmodule
