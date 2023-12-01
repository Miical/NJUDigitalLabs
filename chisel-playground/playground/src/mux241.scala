import chisel3._
import chisel3.util.MuxLookup
class mux241 extends Module {
    val io = IO(new Bundle {
        val in = Input(Vec(4, UInt(2.W)))
        val out = Output(UInt(2.W))
        val sel = Input(UInt(2.W))
    })

    io.out := MuxLookup(io.sel, io.in(0))(Seq(
        (0.U) -> io.in(0),
        (1.U) -> io.in(1),
        (2.U) -> io.in(2),
        (3.U) -> io.in(3)
    ))
}

