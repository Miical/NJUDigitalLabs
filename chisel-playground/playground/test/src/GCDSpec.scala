import chisel3._
import chiseltest._
import chisel3.experimental.BundleLiterals._

import utest._

/**
  * This is a trivial example of how to run this Specification
  * From within sbt use:
  * {{{
  * testOnly gcd.GcdDecoupledTester
  * }}}
  * From a terminal shell use:
  * {{{
  * sbt 'testOnly gcd.GcdDecoupledTester'
  * }}}
  */
object GCDSpec extends ChiselUtestTester {
  val tests = Tests {
    test("GCD") {
      testCircuit(new DecoupledGcd(16)) {
        dut =>
          dut.input.initSource()
          dut.input.setSourceClock(dut.clock)
          dut.output.initSink()
          dut.output.setSinkClock(dut.clock)
          val testValues = for {x <- 0 to 10; y <- 0 to 10} yield (x, y)
          val inputSeq = testValues.map { case (x, y) => (new GcdInputBundle(16)).Lit(_.value1 -> x.U, _.value2 -> y.U) }
          val resultSeq = testValues.map { case (x, y) =>
            (new GcdOutputBundle(16)).Lit(_.value1 -> x.U, _.value2 -> y.U, _.gcd -> BigInt(x).gcd(BigInt(y)).U)
          }
          fork {
            // push inputs into the calculator, stall for 11 cycles one third of the way
            val (seq1, seq2) = inputSeq.splitAt(resultSeq.length / 3)
            dut.input.enqueueSeq(seq1)
            dut.clock.step(11)
            dut.input.enqueueSeq(seq2)
          }.fork {
            // retrieve computations from the calculator, stall for 10 cycles one half of the way
            val (seq1, seq2) = resultSeq.splitAt(resultSeq.length / 2)
            dut.output.expectDequeueSeq(seq1)
            dut.clock.step(10)
            dut.output.expectDequeueSeq(seq2)
          }.join()
      }
    }
  }
}

object encode83Spec extends ChiselUtestTester {
  val tests = Tests {
    test("encode83") {
      testCircuit(new encode83()) {
        dut =>
          dut.io.in.poke(0.U)
          dut.clock.step(1)
          dut.io.out_bin.expect(0.U)
          dut.io.ind.expect(0.U)

          for (i <- 1 to 7) {
            // dut.io.in.poke((1 << (i - 1)).U)
            dut.io.in.poke(1 << (i - 1))
            dut.clock.step(1)
            dut.io.out_bin.expect(i - 1)
            dut.io.ind.expect(1.U)
          }
      }
    }
  }
}
