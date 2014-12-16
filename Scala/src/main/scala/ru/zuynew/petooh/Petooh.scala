package ru.zuynew.petooh

import java.io.FileNotFoundException

import scala.util.matching.Regex
import scala.util.parsing.combinator.RegexParsers

case class State(memory: List[Int], pos: Int, level: Int, stack: List[List[Expression]]) {
  def pushExpr(expr: Expression): State = {
    this.copy(
      stack = stack.patch(
        level-1,
        Seq(
          stack(level-1) ++ List(expr)
        ),
        1
      )
    )
  }
}

case class PetoohSyntaxErrorException() extends Exception

trait Expression

case class IncrementPointerExpression() extends Expression
case class DecrementPointerExpression() extends Expression
case class IncrementMemoryAtPointerExpression() extends Expression
case class DecrementMemoryAtPointerExpression() extends Expression
case class OutputMemoryAtPointerExpression() extends Expression
case class JumpExpression() extends Expression
case class ReturnExpression() extends Expression

class PetoohParser extends RegexParsers {

  override protected val whiteSpace: Regex = "\\s+|-".r

  def parse(source:String) = parseAll(petooh, source)

  def petooh: Parser[List[Expression]] = rep(instruction)

  def instruction: Parser[Expression] = token

  def token: Parser[Expression] = outputMemoryAtPointer ||| incrementPointer ||| decrementPointer ||| jmp ||| ret ||| incrementMemoryAtPointer ||| decrementMemoryAtPointer

  def incrementPointer: Parser[Expression] = "Kudah" ^^ {
    case ops => IncrementPointerExpression()
  }

  def decrementPointer: Parser[Expression] = "kudah" ^^ {
    case ops => DecrementPointerExpression()
  }

  def incrementMemoryAtPointer: Parser[Expression] = "Ko" ^^ {
    case ops => IncrementMemoryAtPointerExpression()
  }

  def decrementMemoryAtPointer: Parser[Expression] = "kO" ^^ {
    case ops => DecrementMemoryAtPointerExpression()
  }

  def outputMemoryAtPointer: Parser[Expression] = "Kukarek" ^^ {
    case ops => OutputMemoryAtPointerExpression()
  }

  def jmp: Parser[Expression] = "Kud" ^^ {
    case ops => JumpExpression()
  }

  def ret: Parser[Expression] = "kud" ^^ {
    case ops => ReturnExpression()
  }
}

object PetoohInterpreter {

  def execute(script: String): Unit = {

    val parser = new PetoohParser

    val res  = parser.parse(script)

    if (res.successful)
    {
      iterate(res.get, State(List(0), 0, 0, List()))
    }
    else
    {
      throw new PetoohSyntaxErrorException
    }

  }

  private def iterate(exprs: List[Expression], state: State): State ={
    exprs match {
      case exp :: tail =>
        val state0 = exp match {
          case IncrementPointerExpression() => incrementPointer(state)
          case DecrementPointerExpression() => decrementPointer(state)
          case IncrementMemoryAtPointerExpression() => incrementMemoryAtPointer(state)
          case DecrementMemoryAtPointerExpression() => decrementMemoryAtPointer(state)
          case OutputMemoryAtPointerExpression() => outputMemoryAtPointer(state)
          case JumpExpression() => jump(state)
          case ReturnExpression() => ret(state)
        }
        iterate(tail, state0)
      case Nil =>
        state
    }
  }

  private def incrementPointer (state: State): State = {
    if (state.level > 0)
    {
      state.pushExpr(IncrementPointerExpression())
    }
    else
    {
      val memory =
        if (state.memory.length <= state.pos+1)
        {
          state.memory ++ List(0)
        }
        else
        {
          state.memory
        }
      state.copy(memory, state.pos+1)
    }
  }

  private def decrementPointer (state: State): State = {
    if (state.level > 0)
    {
      state.pushExpr(DecrementPointerExpression())
    }
    else
    {
      if (state.pos-1 < 0) {
        throw new IndexOutOfBoundsException
      }
      state.copy(state.memory, state.pos-1)
    }
  }

  private def incrementMemoryAtPointer (state: State): State = {
    if (state.level > 0)
    {
      state.pushExpr(IncrementMemoryAtPointerExpression())
    }
    else
    {
      state.copy(
        state.memory.patch(
          state.pos,
          Seq(state.memory(state.pos) + 1),
          1
        )
      )
    }
  }

  private def decrementMemoryAtPointer (state: State): State = {
    if (state.level > 0)
    {
      state.pushExpr(DecrementMemoryAtPointerExpression())
    }
    else
    {
      state.copy(
        state.memory.patch(
          state.pos,
          Seq(state.memory(state.pos) - 1),
          1
        )
      )
    }
  }

  private def outputMemoryAtPointer (state: State): State = {
    if (state.level > 0)
    {
      state.pushExpr(OutputMemoryAtPointerExpression())
    }
    else
    {
      print(state.memory(state.pos).toChar)
      state
    }
  }

  private def jump (state: State): State = {
    state.copy(
      level = state.level+1,
      stack = state.stack ++ List(List())
    )
  }

  private def ret (state: State): State = {

    def cycle (exprs: List[Expression], state: State): State = {
      if (state.memory(state.pos) > 0)
      {
        val state0 = iterate(exprs, state)
        cycle(exprs, state0)
      }
      else
      {
        state
      }
    }
    val state0 = cycle(
      state.stack(state.level-1),
      state.copy(
        level = 0,
        stack = List()
      )
    )
    state0.copy(
      level = state.level-1,
      stack = state.stack.patch(state.level-1, Nil, 1)
    )
  }
}

object Petooh extends App {
  if (args.length < 1)
  {
    println("USAGE: Petooh /path/to/file.koko")
    sys.exit(1)
  }

  try
  {
    PetoohInterpreter.execute(scala.io.Source.fromFile(args(0)).mkString)
  }
  catch
  {
    case e: FileNotFoundException =>
      println("File not found")
      sys.exit(1)
    case e: PetoohSyntaxErrorException =>
      println("Petooh syntax error")
      sys.exit(1)
    case e: Exception => throw e
  }

}
