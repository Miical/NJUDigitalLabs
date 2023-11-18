module keyboard (
    input clk,
    input rst,
    input kbd_clk, kbd_data,

    output [7:0] seg0,
    output [7:0] seg1,

    output [7:0] seg2,
    output [7:0] seg3,

    output [7:0] seg6,
    output [7:0] seg7
);

/* ps2_keyboard interface signals */
wire [7:0] data;
wire ready, overflow;
wire nextdata_n = 1'b0;

ps2_keyboard inst(
    .clk(clk),
    .clrn(~rst),
    .ps2_clk(kbd_clk),
    .ps2_data(kbd_data),
    .data(data),
    .ready(ready),
    .nextdata_n(nextdata_n),
    .overflow(overflow)
);

reg [7:0] cnt;
reg [1:0] state;
reg [7:0] curdata;
reg [7:0] ascii;

key2ascii inst2(
    .clk(clk),
    .kbd_data(curdata),
    .ascii(ascii)
);

bcd7seg bcd7seg0(.b(curdata[3:0]), .h(seg0));
bcd7seg bcd7seg1(.b(curdata[7:4]), .h(seg1));

bcd7seg bcd7seg2(.b(ascii[3:0]), .h(seg2));
bcd7seg bcd7seg3(.b(ascii[7:4]), .h(seg3));

bcd7seg bcd7seg6(.b(cnt[3:0]), .h(seg6));
bcd7seg bcd7seg7(.b(cnt[7:4]), .h(seg7));

always @(posedge clk) begin
    if (rst == 0 && ready) begin
        $display("keyboard: %x", data);
        if (state == 2'b00) begin
            cnt <= cnt + 8'b1;
            curdata <= data;
            state <= 2'b01;
        end else if (state == 2'b01) begin
            if (data == 8'hf0)
                state <= 2'b10;
        end else if (state == 2'b10) begin
            state <= 2'b00;
        end
    end
end


initial begin
    cnt = 0;
    state = 0;
end

endmodule
