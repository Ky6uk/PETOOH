<?php

  class Interpreter {

    const OP_INC = "Ko";
    const OP_DEC = "kO";
    const OP_INCPTR = "Kudah";
    const OP_DECPTR = "kudah";
    const OP_OUT = "Kukarek";
    const OP_JMP = "Kud";
    const OP_RET = "kud";
    const VALID_CHARS = "adehkKoOru";

    private $cells = [];
    private $cellptr = 0;
    private $stack = [];
    private $level = 0;

    private function _push ($instruction) {
      $this->stack[$this->level][] = $instruction;
    }

    private function _loop () {
      while ($this->cells[$this->cellptr] > 0)
        foreach ($this->stack[$this->level] as $instruction)  {
        if (!array_key_exists($this->cellptr, $this->cells))
          $this->cells[$this->cellptr] = 0;
        if ($instruction == self::OP_INC) $this->cells[$this->cellptr] += 1;
        elseif ($instruction == self::OP_DEC) $this->cells[$this->cellptr] -= 1;
        elseif ($instruction == self::OP_INCPTR) $this->cellptr += 1;
        elseif ($instruction == self::OP_DECPTR) $this->cellptr -= 1;
        elseif ($instruction == self::OP_OUT) print(chr($this->cells[$this->cellptr]));
      }
    }

    public function evaluate ($code) {
      $code = str_split(preg_replace("/[^" . self::VALID_CHARS . "]*/", '', $code));
      $buffer = '';

      foreach ($code as $char) {
        $instruction = $buffer . $char;

        if (!array_key_exists($this->cellptr, $this->cells))
          $this->cells[$this->cellptr] = 0;

        if ($instruction == self::OP_INC) {
          $buffer = '';
          if ($this->level > 0) 
            $this->_push($instruction);
          else 
            $this->cells[$this->cellptr] += 1;
        } elseif ($instruction == self::OP_DEC) {
            $buffer = '';
            if ($this->level > 0)
                $this->_push($instruction);
            else
                $this->cells[$this->cellptr] -= 1;
        } elseif ($instruction == self::OP_INCPTR) {
            $buffer = '';
            if ($this->level > 0)
                $this->_push($instruction);
            else
                $this->cellptr += 1;
        } elseif ($instruction == self::OP_DECPTR) {
            $buffer = '';
            if ($this->level > 0) 
                $this->_push($instruction);
            else
                $this->cellptr -= 1;
        } elseif ($buffer == self::OP_JMP && $char != 'a') {
            $buffer = $char;
            $this->level += 1;
            $this->stack[$this->level] = [];
        } elseif ($buffer == self::OP_RET && $char != 'a') {
            $buffer = $char;
            $this->_loop();
            $this->level -= 1;
        } elseif ($instruction == self::OP_OUT) {
            $buffer = '';
            if ($this->level > 0)
                $this->_push($instruction);
            else
                print(chr($this->cells[$this->cellptr]));
        } else
            $buffer .= $char;
      }
    }

  }

  if (count($argv) == 2) {
    try {
      $interpreter = new Interpreter();
      $interpreter->evaluate(file_get_contents($argv[1]));
    }
    catch (Exception $e) {
      print $e;
    }
  } else {
    printf("\n    USAGE: php %s /path/to/file.koko\r\n", $argv[0]);
  }
