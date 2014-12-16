import java.io.{ByteArrayOutputStream, PrintStream}

import org.junit.{After, Before, Test}
import org.junit.Assert.assertEquals

import org.junit.runner.RunWith
import org.junit.runners.JUnit4

import ru.zuynew.petooh.PetoohInterpreter

class PetoohTest {

  private val outContent: ByteArrayOutputStream = new ByteArrayOutputStream()
  private val errContent: ByteArrayOutputStream = new ByteArrayOutputStream()

  @Before
  def setUpStreams(): Unit = {
    System.setOut(new PrintStream(outContent))
    System.setErr(new PrintStream(errContent))
  }

  @Test
  def executeTest(): Unit = {
    PetoohInterpreter.execute("KoKoKoKoKoKoKoKoKoKo Kud-Kudah\nKoKoKoKoKoKoKoKo kudah kO kud-Kudah Kukarek kudah\nKoKoKo Kud-Kudah\nkOkOkOkO kudah kO kud-Kudah Ko Kukarek kudah\nKoKoKoKo Kud-Kudah KoKoKoKo kudah kO kud-Kudah kO Kukarek\nkOkOkOkOkO Kukarek Kukarek kOkOkOkOkOkOkO\nKukarek")
    assertEquals("PETOOH", outContent.toString())
  }

  @After
  def cleanUpStreams(): Unit = {
    System.setOut(null)
    System.setErr(null)
  }

}