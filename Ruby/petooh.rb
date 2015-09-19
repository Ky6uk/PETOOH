#!/usr/bin/env ruby
# encoding: UTF-8
# require 'petooh'
# encoding: UTF-8

# Generated from "lib/petooh.peg" on 2015-09-20 02:31:43 +0500

# 
module PETOOH

  # 
  # +program+ is an Array of PETOOH keywords (in the form of String-s).
  #
  # +debug+ - if true then PETOOH VM state is dumped on each execution step.
  # 
  def run(program, debug = false)
    # Init virtual machine.
    mem = [0] * 16
    data_ptr = 0
    pc = 0  # Index of current instruction in program.
    # Run!
    while pc < program.size
      # Log (if needed).
      if debug
        STDERR.puts "MEM: #{mem.join(" ")}"
        STDERR.puts "PC: #{pc} (#{program[pc]})"
        STDERR.puts "DP: #{data_ptr} (#{mem[data_ptr]})"
      end
      # Analyze current program instruction.
      case program[pc]
      when "Kudah"
        # 
        data_ptr += 1
        # Expand memory if needed.
        if data_ptr >= mem.size
          mem.concat([0] * 16)
        end
        # 
        pc += 1
      when "kudah"
        # 
        data_ptr -= 1
        # Convert the machine's state from the form of
        #   { data_ptr = -1, mem = { -1:x, 0:y, 1:z, … } }
        # to the form of
        #   { data_ptr = 0, mem = { 0:x, 1:y, 2:z, … } }
        if data_ptr < 0
          mem.unshift(0)
          data_ptr = 0
        end
        # 
        pc += 1
      when "Ko"
        mem[data_ptr] += 1
        pc += 1
      when "kO"
        mem[data_ptr] -= 1
        pc += 1
      when "Kukarek"
        print mem[data_ptr].chr
        pc += 1
      when "Kud"
        if mem[data_ptr] == 0
          # Increment PC until corresponding "kud" is encountered
          # (taking nested "Kud"/"kud" into account).
          nest_level = 1
          pc += 1
          while pc < program.size and nest_level > 0
            case program[pc]
            when "Kud"
              nest_level += 1
            when "kud"
              nest_level -= 1
            end
            pc += 1
          end
        else
          # Just skip the instruction.
          pc += 1
        end
      when "kud"
        if mem[data_ptr] != 0
          # Decrement PC until corresponding "Kud" is encountered
          # (taking nested "Kud"/"kud" into account).
          nest_level = 1
          pc -= 1
          while pc > 0 and nest_level > 0
            case program[pc]
            when "Kud"
              nest_level -= 1
            when "kud"
              nest_level += 1
            end
            pc -= 1
          end
          # Position PC right to the corresponding "Kud".
          pc += 1
        else
          # Just skip the instruction.
          pc += 1
        end
      end
    end
  end
  
  # 
  # reads PETOOH program from +io+ and parses it into Array of PETOOH
  # keywords (in the form of String-s).
  # 
  def parse(io)
    yy_parse(io)
  end
  
  private
  

      
      # 
      # +input+ is IO. It must have working IO#pos, IO#pos= and
      # IO#set_encoding() methods.
      # 
      # It may raise YY_SyntaxError.
      # 
      def yy_parse(input)
        input.set_encoding("UTF-8", "UTF-8")
        context = YY_ParsingContext.new(input)
        yy_from_pcv(
          yy_nonterm1(context) ||
          # TODO: context.worst_error can not be nil here. Prove it.
          raise(context.worst_error)
        )
      end

      # TODO: Allow to pass String to the entry point.
    
      
      # :nodoc:
      ### converts value to parser-compatible value (which is always non-false and
      ### non-nil).
      def yy_to_pcv(value)
        if value.nil? then :yy_nil
        elsif value == false then :yy_false
        else value
        end
      end
      
      # :nodoc:
      ### converts value got by #yy_to_pcv() to actual value.
      def yy_from_pcv(value)
        if value == :yy_nil then nil
        elsif value == :yy_false then false
        else value
        end
      end
      
      # :nodoc:
      class YY_ParsingContext
        
        # +input+ is IO.
        def initialize(input)
          @input = input
          @worst_error = nil
        end
        
        attr_reader :input
        
        # It is YY_SyntaxExpectationError or nil.
        attr_accessor :worst_error
        
        # adds possible error to this YY_ParsingContext.
        # 
        # +error+ is YY_SyntaxExpectationError.
        # 
        def << error
          # Update worst_error.
          if worst_error.nil? or worst_error.pos < error.pos then
            @worst_error = error
          elsif worst_error.pos == error.pos then
            @worst_error = @worst_error.or error
          end
          # 
          return self
        end
        
      end
      
      # :nodoc:
      def yy_string(context, string)
        # 
        string_start_pos = context.input.pos
        # Read string.
        read_string = context.input.read(string.bytesize)
        # Set the string's encoding; check if it fits the argument.
        unless read_string and (read_string.force_encoding(Encoding::UTF_8)) == string then
          # 
          context << YY_SyntaxExpectationError.new(yy_displayed(string), string_start_pos)
          # 
          return nil
        end
        # 
        return read_string
      end
      
      # :nodoc:
      def yy_end?(context)
        #
        if not context.input.eof?
          context << YY_SyntaxExpectationError.new("the end", context.input.pos)
          return nil
        end
        #
        return true
      end
      
      # :nodoc:
      def yy_begin?(context)
        #
        if not(context.input.pos == 0)
          context << YY_SyntaxExpectationError.new("the beginning", context.input.pos)
          return nil
        end
        #
        return true
      end
      
      # :nodoc:
      def yy_char(context)
        # 
        char_start_pos = context.input.pos
        # Read a char.
        c = context.input.getc
        # 
        unless c then
          #
          context << YY_SyntaxExpectationError.new("a character", char_start_pos)
          #
          return nil
        end
        #
        return c
      end
      
      # :nodoc:
      def yy_char_range(context, from, to)
        # 
        char_start_pos = context.input.pos
        # Read the char.
        c = context.input.getc
        # Check if it fits the range.
        # NOTE: c has UTF-8 encoding.
        unless c and (from <= c and c <= to) then
          # 
          context << YY_SyntaxExpectationError.new(%(#{yy_displayed from}...#{yy_displayed to}), char_start_pos)
          # 
          return nil
        end
        #
        return c
      end
      
      # :nodoc:
      ### The form of +string+ suitable for displaying in messages.
      def yy_displayed(string)
        if string.length == 1 then
          char = string[0]
          char_code = char.ord
          case char_code
          when 0x00...0x20, 0x2028, 0x2029 then %(#{yy_unicode_s char_code})
          when 0x20...0x80 then %("#{char}")
          when 0x80...Float::INFINITY then %("#{char} (#{yy_unicode_s char_code})")
          end
        else
          %("#{string}")
        end
      end
      
      # :nodoc:
      ### "U+XXXX" string corresponding to +char_code+.
      def yy_unicode_s(char_code)
        "U+#{"%04X" % char_code}"
      end
      
      class YY_SyntaxError < Exception
        
        def initialize(message, pos)
          super(message)
          @pos = pos
        end
        
        attr_reader :pos
        
      end
      
      # :nodoc:
      class YY_SyntaxExpectationError < YY_SyntaxError
        
        # 
        # +expectations+ are String-s.
        # 
        def initialize(*expectations, pos)
          super(nil, pos)
          @expectations = expectations
        end
        
        # 
        # returns other YY_SyntaxExpectationError with #expectations combined.
        # 
        # +other+ is another YY_SyntaxExpectationError.
        # 
        # #pos of this YY_SyntaxExpectationError and +other+ must be equal.
        # 
        def or other
          raise %(can not "or" #{YY_SyntaxExpectationError}s with different pos) unless self.pos == other.pos
          YY_SyntaxExpectationError.new(*(self.expectations + other.expectations), pos)
        end
        
        def message
          expectations = self.expectations.uniq
          (
            if expectations.size == 1 then expectations.first
            else [expectations[0...-1].join(", "), expectations[-1]].join(" or ")
            end
          ) + " is expected"
        end
        
        protected
        
        # Private
        attr_reader :expectations
        
      end
    
      # :nodoc:
      def yy_nonterm1(yy_context)
        val = nil
        (begin
       val = [] 
      true
    end and while true
      yy_var8 = yy_context.input.pos
      if not(begin; yy_var6 = yy_context.input.pos; begin
      yy_var7 = yy_nonterm9(yy_context)
      if yy_var7 then
        val << yy_from_pcv(yy_var7)
      end
      yy_var7
    end or (yy_context.input.pos = yy_var6; yy_nontermh(yy_context)); end) then
        yy_context.input.pos = yy_var8
        break true
      end
    end) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm9(yy_context)
        val = nil
        begin
      val = ""
      yy_varf = yy_context.input.pos
      begin; yy_vare = yy_context.input.pos; yy_string(yy_context, "Kudah") or (yy_context.input.pos = yy_vare; yy_string(yy_context, "kudah")) or (yy_context.input.pos = yy_vare; yy_string(yy_context, "Ko")) or (yy_context.input.pos = yy_vare; yy_string(yy_context, "kO")) or (yy_context.input.pos = yy_vare; yy_string(yy_context, "Kukarek")) or (yy_context.input.pos = yy_vare; yy_string(yy_context, "Kud")) or (yy_context.input.pos = yy_vare; yy_string(yy_context, "kud")); end and begin
        yy_varg = yy_context.input.pos
        yy_context.input.pos = yy_varf
        val << yy_context.input.read(yy_varg - yy_varf).force_encoding(Encoding::UTF_8)
      end
    end and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nontermh(yy_context)
        val = nil
        yy_char(yy_context) and yy_to_pcv(val)
      end
    
end



# Parse args.
case ARGV
when [], ["-h"], ["--help"]
  puts <<-HELP
Usage: ruby #{File.basename(__FILE__)} file.koko
  HELP
  exit
end
file = ARGV[0]
# Run!
include PETOOH
File.open(file) do |io|
  program = parse(io)
  run program
end
