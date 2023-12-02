import chisel3._
import chisel3.util.PriorityEncoder
import chisel3.util.Reverse
import chisel3.util.MuxLookup

class SevenSegmentDisplay extends Module{
    val io = IO(new Bundle{
        val in = Input(UInt(4.W))
        val en = Input(Bool())
        val out = Output(UInt(7.W))
    })

    io.out := Mux(io.en, MuxLookup(io.in, 0.U)(Seq(
        (0.U)  -> "b1000000".U,
        (1.U)  -> "b1111001".U,
        (2.U)  -> "b0100100".U,
        (3.U)  -> "b0110000".U,
        (4.U)  -> "b0011001".U,
        (5.U)  -> "b0010010".U,
        (6.U)  -> "b0000010".U,
        (7.U)  -> "b1111000".U,
        (8.U)  -> "b0000000".U,
        (9.U)  -> "b0010000".U,
        (10.U) -> "b0001000".U,
        (11.U) -> "b0000011".U,
        (12.U) -> "b1000110".U,
        (13.U) -> "b0100001".U,
        (14.U) -> "b0000110".U,
        (15.U) -> "b0001110".U
    )), 0.U)
}


class encode83 extends Module{
    val io = IO(new Bundle{
        val in = Input(UInt(8.W))
        val out_seg = Output(UInt(7.W))
        val out_bin = Output(UInt(3.W))
        val ind = Output(Bool())
    })

    io.out_bin := ~PriorityEncoder(Reverse(io.in))
    io.ind := io.in.orR

    val seg = Module(new SevenSegmentDisplay())
    seg.io.in := io.out_bin
    seg.io.en := io.ind

    io.out_seg := seg.io.out
}
