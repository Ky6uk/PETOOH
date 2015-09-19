#!/usr/bin/ruby
# encoding: UTF-8

      
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
      
    code = code("")
    rule_is_first = true
    method_names = HashMap.new
  
      true
    end and yy_nontermgh(yy_context) and while true
      yy_varc = yy_context.input.pos
      if not(begin; yy_var8 = yy_context.input.pos; (begin
      yy_var9 = yy_context.input.pos
      if yy_var9 then
        rule_pos = yy_from_pcv(yy_var9)
      end
      yy_var9
    end and begin
      yy_vara = yy_nonterm2e(yy_context)
      if yy_vara then
        rule = yy_from_pcv(yy_vara)
      end
      yy_vara
    end and begin
      
        # Check that the rule is not defined twice.
        if method_names.has_key?(rule.name) then
          raise YY_SyntaxError.new(%(rule #{rule.name} is defined more than once), rule_pos)
        end
        # 
        if rule_is_first
          code += parser_entry_point_code("yy_parse", rule.method_name)
          code += auxiliary_parser_code
          rule_is_first = false
        end
        # 
        if rule.need_entry_point?
          code += parser_entry_point_code(rule.entry_point_method_name, rule.method_name)
        end
        #
        code += rule.method_definition
        # 
        method_names[rule.name] = rule.method_name
      
      true
    end) or (yy_context.input.pos = yy_var8; (begin
      yy_varb = yy_nonterm4p(yy_context)
      if yy_varb then
        code_insertion = yy_from_pcv(yy_varb)
      end
      yy_varb
    end and begin
      
        code += code_insertion
      
      true
    end)); end) then
        yy_context.input.pos = yy_varc
        break true
      end
    end and yy_end?(yy_context) and begin
      
    code = link(code, method_names)
    check_no_unresolved_code_in code
    val = code
  
      true
    end) and yy_to_pcv(val)
      end
      
  def parser_entry_point_code(method_name, parsing_method_name)
    code %(
      
      # 
      # +input+ is IO. It must have working IO#pos, IO#pos= and
      # IO#set_encoding() methods.
      # 
      # It may raise YY_SyntaxError.
      # 
      def #{method_name}(input)
        input.set_encoding("UTF-8", "UTF-8")
        context = YY_ParsingContext.new(input)
        yy_from_pcv(
          #{parsing_method_name}(context) ||
          # TODO: context.worst_error can not be nil here. Prove it.
          raise(context.worst_error)
        )
      end

      # TODO: Allow to pass String to the entry point.
    )
  end
  
  # 
  # See source code.
  # 
  def link(code, method_names)
    code.map do |code_part|
      if code_part.is_a? UnknownMethodCall and method_names.has_key? code_part.nonterminal
        code "#{method_names[code_part.nonterminal]}(#{code_part.args_code.to_s})"
      else
        code_part
      end
    end
  end
  
  def check_no_unresolved_code_in code
    code.each do |code_part|
      case code_part
      when UnknownMethodCall
        raise YY_SyntaxError.new(%(rule #{code_part.nonterminal} is not defined), code_part.source_pos)
      when LazyRepeat::UnknownLookAheadCode
        raise YY_SyntaxError.new(%(at least one expression is expected to be in sequence with "*?" expression), code_part.source_pos)
      end
    end
  end
  
  def auxiliary_parser_code
    code %(
      
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
          context << YY_SyntaxExpectationError.new(%(\#{yy_displayed from}\...\#{yy_displayed to}), char_start_pos)
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
          when 0x00...0x20, 0x2028, 0x2029 then %(\#{yy_unicode_s char_code})
          when 0x20...0x80 then %("\#{char}")
          when 0x80...Float::INFINITY then %("\#{char} (\#{yy_unicode_s char_code})")
          end
        else
          %("\#{string}")
        end
      end
      
      # :nodoc:
      ### "U+XXXX" string corresponding to +char_code+.
      def yy_unicode_s(char_code)
        "U+\#{"%04X" % char_code}"
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
          raise %(can not "or" \#{YY_SyntaxExpectationError}s with different pos) unless self.pos == other.pos
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
    )
  end
  

      # :nodoc:
      def yy_nonterme(yy_context)
        val = nil
        begin
      yy_varg = yy_nontermh(yy_context)
      if yy_varg then
        val = yy_from_pcv(yy_varg)
      end
      yy_varg
    end and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nontermh(yy_context)
        val = nil
        (begin
      
    single_expression = true
    remembered_pos_var = new_unique_variable_name
  
      true
    end and begin
      yy_vark = yy_context.input.pos
      if not(yy_nonterm8r(yy_context)) then
        yy_context.input.pos = yy_vark
      end
      true
    end and begin
      yy_varl = yy_nonterms(yy_context)
      if yy_varl then
        val = yy_from_pcv(yy_varl)
      end
      yy_varl
    end and while true
      yy_varr = yy_context.input.pos
      if not((yy_nonterm8r(yy_context) and begin
      yy_varq = yy_nonterms(yy_context)
      if yy_varq then
        val2 = yy_from_pcv(yy_varq)
      end
      yy_varq
    end and begin
      
      single_expression = false
      val = val + (code " or (yy_context.input.pos = #{remembered_pos_var}; ") + val2 + (code ")")
    
      true
    end)) then
        yy_context.input.pos = yy_varr
        break true
      end
    end and begin
      
    if not single_expression then
      val = (code "begin; #{remembered_pos_var} = yy_context.input.pos; ") + val + (code "; end")
    end
  
      true
    end) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterms(yy_context)
        val = nil
        (begin
       code_parts = [] 
      true
    end and begin; yy_varx = yy_context.input.pos; (begin
      yy_vary = yy_nonterm11(yy_context)
      if yy_vary then
        code_part = yy_from_pcv(yy_vary)
      end
      yy_vary
    end and begin
       code_parts.add code_part 
      true
    end) or (yy_context.input.pos = yy_varx; (yy_nonterm93(yy_context) and begin
       code_parts = [sequence_code(code_parts)] 
      true
    end)); end and while true
      yy_varz = yy_context.input.pos
      if not(begin; yy_varx = yy_context.input.pos; (begin
      yy_vary = yy_nonterm11(yy_context)
      if yy_vary then
        code_part = yy_from_pcv(yy_vary)
      end
      yy_vary
    end and begin
       code_parts.add code_part 
      true
    end) or (yy_context.input.pos = yy_varx; (yy_nonterm93(yy_context) and begin
       code_parts = [sequence_code(code_parts)] 
      true
    end)); end) then
        yy_context.input.pos = yy_varz
        break true
      end
    end and begin
       val = sequence_code(code_parts) 
      true
    end) and yy_to_pcv(val)
      end
      
  def sequence_code(sequence_parts)
    # 
    lazy_kleene_star_part_index =
      sequence_parts.find_index { |sequence_part| sequence_part.any? { |code_part| code_part.is_a? LazyRepeat::UnknownLookAheadCode } }
    # Compile parts after "*?" part as look ahead of the "*?" part
    # (if possible).
    if lazy_kleene_star_part_index and lazy_kleene_star_part_index != (sequence_parts.size - 1)
      lazy_kleene_star_part = sequence_parts[lazy_kleene_star_part_index]
      sequence_parts_after_lazy_kleene_star_part = sequence_parts[(lazy_kleene_star_part_index+1)..-1]
      lazy_kleene_star_part = lazy_kleene_star_part.replace(
        LazyRepeat::UnknownLookAheadCode,
        sequence_code(sequence_parts_after_lazy_kleene_star_part)
      )
      sequence_parts[lazy_kleene_star_part_index] = lazy_kleene_star_part
    end
    # Compile the code parts into sequence code!
    if sequence_parts.size == 1
      sequence_parts.first
    else
      code("(") + sequence_parts.reduce { |r, sequence_part| r + code(" and ") + sequence_part } + code(")")
    end
  end
  

      # :nodoc:
      def yy_nonterm11(yy_context)
        val = nil
        begin; yy_var12 = yy_context.input.pos; (begin
      yy_var13 = yy_nonterm18(yy_context)
      if yy_var13 then
        c = yy_from_pcv(yy_var13)
      end
      yy_var13
    end and begin
      yy_var14 = yy_nonterm4a(yy_context)
      if yy_var14 then
        t = yy_from_pcv(yy_var14)
      end
      yy_var14
    end and begin
      yy_var15 = yy_nonterm46(yy_context)
      if yy_var15 then
        var = yy_from_pcv(yy_var15)
      end
      yy_var15
    end and begin
       val = capture_semantic_value_code(var, c, t) 
      true
    end) or (yy_context.input.pos = yy_var12; begin
      yy_var16 = yy_nonterm18(yy_context)
      if yy_var16 then
        val = yy_from_pcv(yy_var16)
      end
      yy_var16
    end); end and yy_to_pcv(val)
      end
      
  # 
  # +capture_type+ may be:
  # 
  # [:capture] "Capture the semantic value to +target_var+"
  # [:append]  "Append semantic value to +target_var+ using "<<" operator".
  # 
  def capture_semantic_value_code(target_var, code, capture_type)
    parse_result_var = new_unique_variable_name
    capture_operator =
      case capture_type
      when :capture then "="
      when :append then "<<"
      else raise %(capture_type #{capture_type.inspect} is not supported)
      end
    #
    code(%(begin
      #{parse_result_var} = )) + code + code(%(
      if #{parse_result_var} then
        #{target_var} #{capture_operator} yy_from_pcv(#{parse_result_var})
      end
      #{parse_result_var}
    end))
  end
  

      # :nodoc:
      def yy_nonterm18(yy_context)
        val = nil
        begin; yy_var19 = yy_context.input.pos; (yy_nonterm9h(yy_context) and begin
      yy_var1a = yy_nonterm4p(yy_context)
      if yy_var1a then
        predicate_code = yy_from_pcv(yy_var1a)
      end
      yy_var1a
    end and begin
       val = positive_predicate_with_native_code_code(predicate_code) 
      true
    end) or (yy_context.input.pos = yy_var19; (yy_nonterm9h(yy_context) and begin
      yy_var1b = yy_nonterm18(yy_context)
      if yy_var1b then
        val = yy_from_pcv(yy_var1b)
      end
      yy_var1b
    end and begin
       val = positive_predicate_code(val) 
      true
    end)) or (yy_context.input.pos = yy_var19; (yy_nonterm9j(yy_context) and begin
      yy_var1c = yy_nonterm18(yy_context)
      if yy_var1c then
        val = yy_from_pcv(yy_var1c)
      end
      yy_var1c
    end and begin
       val = negative_predicate_code(val) 
      true
    end)) or (yy_context.input.pos = yy_var19; begin
      yy_var1d = yy_nonterm1f(yy_context)
      if yy_var1d then
        val = yy_from_pcv(yy_var1d)
      end
      yy_var1d
    end); end and yy_to_pcv(val)
      end
      
  def positive_predicate_with_native_code_code(native_code)
    code(%(begin \n )) + native_code + code(%( \n end))  # Newlines are needed because native_code may contain comments.
  end
  
  def positive_predicate_code(code)
    stored_pos_var = new_unique_variable_name
    result_var = new_unique_variable_name
    #
    code(%(begin
      #{stored_pos_var} = yy_context.input.pos
      #{result_var} = )) + code + code(%(
      yy_context.input.pos = #{stored_pos_var}
      #{result_var}
    end))
  end
  
  def negative_predicate_code(code)
    stored_worst_error_var = new_unique_variable_name
    result_var = new_unique_variable_name
    # 
    code(%{begin
      #{stored_worst_error_var} = yy_context.worst_error
      #{result_var} = not(}) + positive_predicate_code(code) + code(%{)
      if #{result_var}
        yy_context.worst_error = #{stored_worst_error_var}
      else
        # NOTE: No errors were added into context but the error is still there.
        yy_context << YY_SyntaxExpectationError.new("different expression", yy_context.input.pos)
      end
      #{result_var}
    end})
  end


      # :nodoc:
      def yy_nonterm1f(yy_context)
        val = nil
        (begin
      yy_var1h = yy_nonterm1p(yy_context)
      if yy_var1h then
        val = yy_from_pcv(yy_var1h)
      end
      yy_var1h
    end and while true
      yy_var1n = yy_context.input.pos
      if not(begin; yy_var1l = yy_context.input.pos; (begin
      yy_var1m = yy_context.input.pos
      if yy_var1m then
        p = yy_from_pcv(yy_var1m)
      end
      yy_var1m
    end and yy_nonterm9b(yy_context) and begin
       val = lazy_repeat_code(val, p) 
      true
    end) or (yy_context.input.pos = yy_var1l; (yy_nonterm99(yy_context) and begin
       val = repeat_many_times_code(val) 
      true
    end)) or (yy_context.input.pos = yy_var1l; (yy_nonterm9f(yy_context) and begin
       val = repeat_at_least_once_code(val) 
      true
    end)) or (yy_context.input.pos = yy_var1l; (yy_nonterm9d(yy_context) and begin
       val = optional_code(val) 
      true
    end)); end) then
        yy_context.input.pos = yy_var1n
        break true
      end
    end) and yy_to_pcv(val)
      end
      
  # 
  # +source_pos+ is position in source code the "lazy repeat" code is compiled
  # from.
  # 
  def lazy_repeat_code(parsing_code, source_pos)
    #
    original_pos_var = new_unique_variable_name
    result_var = new_unique_variable_name
    #
    code(%{ begin
      while true
        ###
        #{original_pos_var} = yy_context.input.pos
        ### Look ahead.
        #{result_var} = }) + LazyRepeat::UnknownLookAheadCode[source_pos] + code(%{
        yy_context.input.pos = #{original_pos_var}
        break if #{result_var}
        ### Repeat one more time (if possible).
        #{result_var} = }) + parsing_code + code(%{
        if not #{result_var} then
          yy_context.input.pos = #{original_pos_var}
          break
        end
      end
      ### The repetition is always successful.
      true
    end })
  end
  
  def repeat_many_times_code(code)
    stored_pos_var = new_unique_variable_name
    #
    code(%{while true
      #{stored_pos_var} = yy_context.input.pos
      if not(}) + code + code(%{) then
        yy_context.input.pos = #{stored_pos_var}
        break true
      end
    end})
  end
  
  def repeat_at_least_once_code(code)
    code + code(%( and )) + repeat_many_times_code(code)
  end
  
  def optional_code(code)
    stored_pos_var = new_unique_variable_name
    #
    code(%{begin
      #{stored_pos_var} = yy_context.input.pos
      if not(}) + code + code(%{) then
        yy_context.input.pos = #{stored_pos_var}
      end
      true
    end})
  end
  

      # :nodoc:
      def yy_nonterm1p(yy_context)
        val = nil
        begin; yy_var1q = yy_context.input.pos; (yy_nonterm8x(yy_context) and begin
      yy_var1r = yy_nonterme(yy_context)
      if yy_var1r then
        val = yy_from_pcv(yy_var1r)
      end
      yy_var1r
    end and yy_nonterm8z(yy_context)) or (yy_context.input.pos = yy_var1q; (yy_nonterm95(yy_context) and begin
      yy_var1s = yy_nonterme(yy_context)
      if yy_var1s then
        c = yy_from_pcv(yy_var1s)
      end
      yy_var1s
    end and yy_nonterm97(yy_context) and begin
      yy_var1t = yy_nonterm4a(yy_context)
      if yy_var1t then
        t = yy_from_pcv(yy_var1t)
      end
      yy_var1t
    end and begin
      yy_var1u = yy_nonterm46(yy_context)
      if yy_var1u then
        var = yy_from_pcv(yy_var1u)
      end
      yy_var1u
    end and begin
       val = capture_text_code(var, c, t) 
      true
    end)) or (yy_context.input.pos = yy_var1q; begin
      yy_var1v = yy_nonterm1x(yy_context)
      if yy_var1v then
        val = yy_from_pcv(yy_var1v)
      end
      yy_var1v
    end); end and yy_to_pcv(val)
      end
      
  # returns code which captures text to specified variable.
  # 
  # +capture_type+ may be one of the following:
  # 
  # [:capture] "Capture the text into the variable +target_variable_name+"
  # [:append]  "Append the text to the variable +target_variable_name+"
  # 
  def capture_text_code(target_variable_name, parsing_code, capture_type)
    #
    init_target_variable_code =
      case capture_type
      when :capture then %(#{target_variable_name} = "")
      when :append then %()
      else raise %(capture_type #{capture_type.inspect} is not supported)
      end
    start_pos_var = new_unique_variable_name
    end_pos_var = new_unique_variable_name
    # 
    code(%(begin
      #{init_target_variable_code}
      #{start_pos_var} = yy_context.input.pos
      )) +
      parsing_code + code(%( and begin
        #{end_pos_var} = yy_context.input.pos
        yy_context.input.pos = #{start_pos_var}
        #{target_variable_name} << yy_context.input.read(#{end_pos_var} - #{start_pos_var}).force_encoding(Encoding::UTF_8)
      end
    end))
  end
  

      # :nodoc:
      def yy_nonterm1x(yy_context)
        val = nil
        begin; yy_var1y = yy_context.input.pos; (begin
      yy_var1z = yy_nonterme5(yy_context)
      if yy_var1z then
        r = yy_from_pcv(yy_var1z)
      end
      yy_var1z
    end and begin
       val = code "yy_char_range(yy_context, #{r.begin.to_ruby_code}, #{r.end.to_ruby_code})" 
      true
    end) or (yy_context.input.pos = yy_var1y; (begin
      yy_var20 = yy_nontermeb(yy_context)
      if yy_var20 then
        s = yy_from_pcv(yy_var20)
      end
      yy_var20
    end and begin
       val = code "yy_string(yy_context, #{s.to_ruby_code})" 
      true
    end)) or (yy_context.input.pos = yy_var1y; (begin
      yy_var21 = yy_context.input.pos
      if yy_var21 then
        n_pos = yy_from_pcv(yy_var21)
      end
      yy_var21
    end and begin
      yy_var22 = yy_nontermc5(yy_context)
      if yy_var22 then
        n = yy_from_pcv(yy_var22)
      end
      yy_var22
    end and begin
       val = UnknownMethodCall[n, %(yy_context), n_pos] 
      true
    end)) or (yy_context.input.pos = yy_var1y; (yy_nonterm9r(yy_context) and begin
       val = code "yy_char(yy_context)" 
      true
    end)) or (yy_context.input.pos = yy_var1y; (begin
      yy_var23 = yy_context.input.pos
      if yy_var23 then
        pos = yy_from_pcv(yy_var23)
      end
      yy_var23
    end and begin
      yy_var24 = yy_nonterm4p(yy_context)
      if yy_var24 then
        action_code = yy_from_pcv(yy_var24)
      end
      yy_var24
    end and begin
       val = compile_action_expression(action_code, pos) 
      true
    end)) or (yy_context.input.pos = yy_var1y; (yy_nonterm8t(yy_context) and begin
       val = code "yy_end?(yy_context)" 
      true
    end)) or (yy_context.input.pos = yy_var1y; (yy_nonterm8v(yy_context) and begin
       val = code "yy_begin?(yy_context)" 
      true
    end)) or (yy_context.input.pos = yy_var1y; (begin; yy_var28 = yy_context.input.pos; (yy_nonterm9l(yy_context) and yy_nonterm9n(yy_context) and begin
      yy_var29 = yy_nontermad(yy_context)
      if yy_var29 then
        pos_variable = yy_from_pcv(yy_var29)
      end
      yy_var29
    end) or (yy_context.input.pos = yy_var28; (yy_nonterma1(yy_context) and begin
      yy_var2a = yy_nontermad(yy_context)
      if yy_var2a then
        pos_variable = yy_from_pcv(yy_var2a)
      end
      yy_var2a
    end)); end and begin
      yy_var2c = yy_context.input.pos
      if not(yy_nonterm7l(yy_context)) then
        yy_context.input.pos = yy_var2c
      end
      true
    end and begin
       val = code "(yy_context.input.pos = #{pos_variable}; true)" 
      true
    end)) or (yy_context.input.pos = yy_var1y; (yy_nonterm9l(yy_context) and begin
       val = code "yy_context.input.pos" 
      true
    end)); end and yy_to_pcv(val)
      end
      
  # +action_code+ is the Code extracted from the "action" expression.
  def compile_action_expression(action_code, pos)
    # Validate action code.
    begin
      RubyVM::InstructionSequence.compile(action_code.to_s)
    rescue SyntaxError => e
      raise YY_SyntaxError.new("Ruby syntax error", pos)
    end
    # Compile the expression!
    code(%(begin
      )) + action_code + code(%(
      true
    end))
    # NOTE: Newline must be present after action's body because it may include
    # comments.
  end
  

      # :nodoc:
      def yy_nonterm2e(yy_context)
        val = nil
        (begin
       rule = val = Rule.new 
      true
    end and begin; yy_var2n = yy_context.input.pos; (begin
      yy_var2o = yy_nontermbl(yy_context)
      if yy_var2o then
        rule_name = yy_from_pcv(yy_var2o)
      end
      yy_var2o
    end and yy_nonterm8x(yy_context) and begin
      yy_var2s = yy_context.input.pos
      if not(begin; yy_var2r = yy_context.input.pos; yy_nonterm9p(yy_context) or (yy_context.input.pos = yy_var2r; yy_nontermb1(yy_context)); end) then
        yy_context.input.pos = yy_var2s
      end
      true
    end and yy_nonterm8z(yy_context) and begin
       rule.need_entry_point! 
      true
    end) or (yy_context.input.pos = yy_var2n; begin
      yy_var2t = yy_nontermc5(yy_context)
      if yy_var2t then
        rule_name = yy_from_pcv(yy_var2t)
      end
      yy_var2t
    end); end and begin
       rule.name = rule_name 
      true
    end and begin
      yy_var2x = yy_context.input.pos
      if not((yy_nonterm7l(yy_context) and yy_nonterm30(yy_context))) then
        yy_context.input.pos = yy_var2x
      end
      true
    end and yy_nonterm7h(yy_context) and begin
      yy_var2y = yy_nonterme(yy_context)
      if yy_var2y then
        c = yy_from_pcv(yy_var2y)
      end
      yy_var2y
    end and yy_nonterm8p(yy_context) and begin
       rule.method_definition = to_method_definition(c, rule.method_name) 
      true
    end) and yy_to_pcv(val)
      end
      
  def to_method_definition(code, method_name)
    code(%(
      # :nodoc:
      def #{method_name}(yy_context)
        val = nil
        )) + code + code(%( and yy_to_pcv(val)
      end
    ))
  end
  

      # :nodoc:
      def yy_nonterm30(yy_context)
        val = nil
        ((begin
      yy_var41 = yy_context.worst_error
      yy_var42 = not(begin
      yy_var43 = yy_context.input.pos
      yy_var44 = yy_nonterm7h(yy_context)
      yy_context.input.pos = yy_var43
      yy_var44
    end)
      if yy_var42
        yy_context.worst_error = yy_var41
      else
        # NOTE: No errors were added into context but the error is still there.
        yy_context << YY_SyntaxExpectationError.new("different expression", yy_context.input.pos)
      end
      yy_var42
    end and yy_char(yy_context)) and yy_nontermgh(yy_context)) and while true
      yy_var45 = yy_context.input.pos
      if not(((begin
      yy_var41 = yy_context.worst_error
      yy_var42 = not(begin
      yy_var43 = yy_context.input.pos
      yy_var44 = yy_nonterm7h(yy_context)
      yy_context.input.pos = yy_var43
      yy_var44
    end)
      if yy_var42
        yy_context.worst_error = yy_var41
      else
        # NOTE: No errors were added into context but the error is still there.
        yy_context << YY_SyntaxExpectationError.new("different expression", yy_context.input.pos)
      end
      yy_var42
    end and yy_char(yy_context)) and yy_nontermgh(yy_context))) then
        yy_context.input.pos = yy_var45
        break true
      end
    end and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm46(yy_context)
        val = nil
        begin; yy_var47 = yy_context.input.pos; begin
      yy_var48 = yy_nontermad(yy_context)
      if yy_var48 then
        val = yy_from_pcv(yy_var48)
      end
      yy_var48
    end or (yy_context.input.pos = yy_var47; (yy_nonterm8x(yy_context) and begin
      yy_var49 = yy_nontermad(yy_context)
      if yy_var49 then
        val = yy_from_pcv(yy_var49)
      end
      yy_var49
    end and yy_nonterm8z(yy_context))); end and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm4a(yy_context)
        val = nil
        begin; yy_var4b = yy_context.input.pos; (yy_nonterm7l(yy_context) and begin
      val = :capture
      true
    end) or (yy_context.input.pos = yy_var4b; (yy_nonterm8l(yy_context) and begin
      val = :append
      true
    end)) or (yy_context.input.pos = yy_var4b; (yy_nonterm8n(yy_context) and begin
      val = :append
      true
    end)); end and yy_to_pcv(val)
      end
    
  # [line, column] corresponding to position in +io+ (+pos+).
  def line_and_column(pos, io)
    @pos = pos
    io.pos = 0
    return line_and_column0(io)
  end


      
      # 
      # +input+ is IO. It must have working IO#pos, IO#pos= and
      # IO#set_encoding() methods.
      # 
      # It may raise YY_SyntaxError.
      # 
      def line_and_column0(input)
        input.set_encoding("UTF-8", "UTF-8")
        context = YY_ParsingContext.new(input)
        yy_from_pcv(
          yy_nonterm4d(context) ||
          # TODO: context.worst_error can not be nil here. Prove it.
          raise(context.worst_error)
        )
      end

      # TODO: Allow to pass String to the entry point.
    
      # :nodoc:
      def yy_nonterm4d(yy_context)
        val = nil
        (begin
       current_line_and_column = [1, 1] 
      true
    end and while true
      yy_var4o = yy_context.input.pos
      if not((begin
      yy_var4l = yy_context.input.pos
      if yy_var4l then
        current_pos = yy_from_pcv(yy_var4l)
      end
      yy_var4l
    end and begin
       if current_pos == @pos then val = current_line_and_column.dup; end 
      true
    end and begin; yy_var4n = yy_context.input.pos; (yy_nontermgz(yy_context) and begin
       current_line_and_column[0] += 1; current_line_and_column[1] = 1 
      true
    end) or (yy_context.input.pos = yy_var4n; (yy_char(yy_context) and begin
       current_line_and_column[1] += 1 
      true
    end)); end)) then
        yy_context.input.pos = yy_var4o
        break true
      end
    end) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm4p(yy_context)
        val = nil
        (begin; yy_var60 = yy_context.input.pos; (yy_string(yy_context, "{") and while true
      yy_var62 = yy_context.input.pos
      if not(yy_nontermgx(yy_context)) then
        yy_context.input.pos = yy_var62
        break true
      end
    end and yy_string(yy_context, "...") and begin
      yy_var6e = yy_context.input.pos
      if not(( begin
      while true
        ###
        yy_var6c = yy_context.input.pos
        ### Look ahead.
        yy_var6d = yy_nontermgz(yy_context)
        yy_context.input.pos = yy_var6c
        break if yy_var6d
        ### Repeat one more time (if possible).
        yy_var6d = yy_nontermgx(yy_context)
        if not yy_var6d then
          yy_context.input.pos = yy_var6c
          break
        end
      end
      ### The repetition is always successful.
      true
    end  and yy_nontermgz(yy_context))) then
        yy_context.input.pos = yy_var6e
      end
      true
    end and begin
      val = ""
      yy_var6r = yy_context.input.pos
       begin
      while true
        ###
        yy_var6p = yy_context.input.pos
        ### Look ahead.
        yy_var6q = begin; yy_var6y = yy_context.input.pos; (yy_string(yy_context, "...") and while true
      yy_var70 = yy_context.input.pos
      if not(yy_nontermgx(yy_context)) then
        yy_context.input.pos = yy_var70
        break true
      end
    end and yy_string(yy_context, "}")) or (yy_context.input.pos = yy_var6y; (yy_string(yy_context, "}") and while true
      yy_var72 = yy_context.input.pos
      if not(yy_nontermgx(yy_context)) then
        yy_context.input.pos = yy_var72
        break true
      end
    end and yy_string(yy_context, "..."))); end
        yy_context.input.pos = yy_var6p
        break if yy_var6q
        ### Repeat one more time (if possible).
        yy_var6q = yy_char(yy_context)
        if not yy_var6q then
          yy_context.input.pos = yy_var6p
          break
        end
      end
      ### The repetition is always successful.
      true
    end  and begin
        yy_var6s = yy_context.input.pos
        yy_context.input.pos = yy_var6r
        val << yy_context.input.read(yy_var6s - yy_var6r).force_encoding(Encoding::UTF_8)
      end
    end and begin; yy_var6y = yy_context.input.pos; (yy_string(yy_context, "...") and while true
      yy_var70 = yy_context.input.pos
      if not(yy_nontermgx(yy_context)) then
        yy_context.input.pos = yy_var70
        break true
      end
    end and yy_string(yy_context, "}")) or (yy_context.input.pos = yy_var6y; (yy_string(yy_context, "}") and while true
      yy_var72 = yy_context.input.pos
      if not(yy_nontermgx(yy_context)) then
        yy_context.input.pos = yy_var72
        break true
      end
    end and yy_string(yy_context, "..."))); end) or (yy_context.input.pos = yy_var60; (begin
      val = ""
      yy_var77 = yy_context.input.pos
      yy_nonterm79(yy_context) and begin
        yy_var78 = yy_context.input.pos
        yy_context.input.pos = yy_var77
        val << yy_context.input.read(yy_var78 - yy_var77).force_encoding(Encoding::UTF_8)
      end
    end and begin
       val = val[1...-1] 
      true
    end)); end and yy_nontermgh(yy_context) and begin
       val = code(val) 
      true
    end) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm79(yy_context)
        val = nil
        (yy_string(yy_context, "{") and  begin
      while true
        ###
        yy_var7f = yy_context.input.pos
        ### Look ahead.
        yy_var7g = yy_string(yy_context, "}")
        yy_context.input.pos = yy_var7f
        break if yy_var7g
        ### Repeat one more time (if possible).
        yy_var7g = begin; yy_var7e = yy_context.input.pos; yy_nonterm79(yy_context) or (yy_context.input.pos = yy_var7e; yy_char(yy_context)); end
        if not yy_var7g then
          yy_context.input.pos = yy_var7f
          break
        end
      end
      ### The repetition is always successful.
      true
    end  and yy_string(yy_context, "}")) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm7h(yy_context)
        val = nil
        (begin; yy_var7k = yy_context.input.pos; yy_string(yy_context, "<-") or (yy_context.input.pos = yy_var7k; yy_string(yy_context, "=")) or (yy_context.input.pos = yy_var7k; yy_string(yy_context, "\u{2190}")); end and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm7l(yy_context)
        val = nil
        (yy_string(yy_context, ":") and (begin
      yy_var89 = yy_context.worst_error
      yy_var8a = not(begin
      yy_var8b = yy_context.input.pos
      yy_var8c = yy_string(yy_context, "+")
      yy_context.input.pos = yy_var8b
      yy_var8c
    end)
      if yy_var8a
        yy_context.worst_error = yy_var89
      else
        # NOTE: No errors were added into context but the error is still there.
        yy_context << YY_SyntaxExpectationError.new("different expression", yy_context.input.pos)
      end
      yy_var8a
    end and begin
      yy_var8h = yy_context.worst_error
      yy_var8i = not(begin
      yy_var8j = yy_context.input.pos
      yy_var8k = yy_string(yy_context, ">>")
      yy_context.input.pos = yy_var8j
      yy_var8k
    end)
      if yy_var8i
        yy_context.worst_error = yy_var8h
      else
        # NOTE: No errors were added into context but the error is still there.
        yy_context << YY_SyntaxExpectationError.new("different expression", yy_context.input.pos)
      end
      yy_var8i
    end) and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm8l(yy_context)
        val = nil
        (yy_string(yy_context, ":+") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm8n(yy_context)
        val = nil
        (yy_string(yy_context, ":>>") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm8p(yy_context)
        val = nil
        (yy_string(yy_context, ";") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm8r(yy_context)
        val = nil
        (yy_string(yy_context, "/") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm8t(yy_context)
        val = nil
        (yy_string(yy_context, "$") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm8v(yy_context)
        val = nil
        (yy_string(yy_context, "^") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm8x(yy_context)
        val = nil
        (yy_string(yy_context, "(") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm8z(yy_context)
        val = nil
        (yy_string(yy_context, ")") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm91(yy_context)
        val = nil
        (yy_string(yy_context, "[") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm93(yy_context)
        val = nil
        (yy_string(yy_context, "]") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm95(yy_context)
        val = nil
        (yy_string(yy_context, "<") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm97(yy_context)
        val = nil
        (yy_string(yy_context, ">") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm99(yy_context)
        val = nil
        (yy_string(yy_context, "*") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm9b(yy_context)
        val = nil
        (yy_string(yy_context, "*?") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm9d(yy_context)
        val = nil
        (yy_string(yy_context, "?") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm9f(yy_context)
        val = nil
        (yy_string(yy_context, "+") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm9h(yy_context)
        val = nil
        (yy_string(yy_context, "&") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm9j(yy_context)
        val = nil
        (yy_string(yy_context, "!") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm9l(yy_context)
        val = nil
        (yy_string(yy_context, "@") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm9n(yy_context)
        val = nil
        (yy_string(yy_context, "=") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm9p(yy_context)
        val = nil
        (yy_string(yy_context, "...") and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterm9r(yy_context)
        val = nil
        (yy_string(yy_context, "char") and begin
      yy_var9x = yy_context.worst_error
      yy_var9y = not(begin
      yy_var9z = yy_context.input.pos
      yy_vara0 = yy_nonterme3(yy_context)
      yy_context.input.pos = yy_var9z
      yy_vara0
    end)
      if yy_var9y
        yy_context.worst_error = yy_var9x
      else
        # NOTE: No errors were added into context but the error is still there.
        yy_context << YY_SyntaxExpectationError.new("different expression", yy_context.input.pos)
      end
      yy_var9y
    end and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterma1(yy_context)
        val = nil
        (yy_string(yy_context, "at") and begin
      yy_vara7 = yy_context.worst_error
      yy_vara8 = not(begin
      yy_vara9 = yy_context.input.pos
      yy_varaa = yy_nonterme3(yy_context)
      yy_context.input.pos = yy_vara9
      yy_varaa
    end)
      if yy_vara8
        yy_context.worst_error = yy_vara7
      else
        # NOTE: No errors were added into context but the error is still there.
        yy_context << YY_SyntaxExpectationError.new("different expression", yy_context.input.pos)
      end
      yy_vara8
    end and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nontermab(yy_context)
        val = nil
        begin; yy_varac = yy_context.input.pos; yy_nonterm9r(yy_context) or (yy_context.input.pos = yy_varac; yy_nonterma1(yy_context)); end and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nontermad(yy_context)
        val = nil
        (begin
      val = ""
      yy_varaz = yy_context.input.pos
      (begin
      yy_varau = yy_context.input.pos
      if not(begin; yy_varat = yy_context.input.pos; yy_string(yy_context, "@") or (yy_context.input.pos = yy_varat; yy_string(yy_context, "$")); end) then
        yy_context.input.pos = yy_varau
      end
      true
    end and yy_nontermbh(yy_context) and while true
      yy_varay = yy_context.input.pos
      if not(yy_nontermbj(yy_context)) then
        yy_context.input.pos = yy_varay
        break true
      end
    end) and begin
        yy_varb0 = yy_context.input.pos
        yy_context.input.pos = yy_varaz
        val << yy_context.input.read(yy_varb0 - yy_varaz).force_encoding(Encoding::UTF_8)
      end
    end and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nontermb1(yy_context)
        val = nil
        (begin
      val = ""
      yy_varbf = yy_context.input.pos
      (yy_nontermbh(yy_context) and while true
      yy_varbe = yy_context.input.pos
      if not(yy_nontermbj(yy_context)) then
        yy_context.input.pos = yy_varbe
        break true
      end
    end) and begin
        yy_varbg = yy_context.input.pos
        yy_context.input.pos = yy_varbf
        val << yy_context.input.read(yy_varbg - yy_varbf).force_encoding(Encoding::UTF_8)
      end
    end and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nontermbh(yy_context)
        val = nil
        begin; yy_varbi = yy_context.input.pos; yy_char_range(yy_context, "a", "z") or (yy_context.input.pos = yy_varbi; yy_string(yy_context, "_")); end and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nontermbj(yy_context)
        val = nil
        begin; yy_varbk = yy_context.input.pos; yy_nontermbh(yy_context) or (yy_context.input.pos = yy_varbk; yy_char_range(yy_context, "0", "9")); end and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nontermbl(yy_context)
        val = nil
        (begin
      val = ""
      yy_varbz = yy_context.input.pos
      (yy_nontermc1(yy_context) and while true
      yy_varby = yy_context.input.pos
      if not(yy_nontermc3(yy_context)) then
        yy_context.input.pos = yy_varby
        break true
      end
    end) and begin
        yy_varc0 = yy_context.input.pos
        yy_context.input.pos = yy_varbz
        val << yy_context.input.read(yy_varc0 - yy_varbz).force_encoding(Encoding::UTF_8)
      end
    end and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nontermc1(yy_context)
        val = nil
        begin; yy_varc2 = yy_context.input.pos; yy_char_range(yy_context, "a", "z") or (yy_context.input.pos = yy_varc2; yy_string(yy_context, "_")); end and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nontermc3(yy_context)
        val = nil
        begin; yy_varc4 = yy_context.input.pos; yy_nontermc1(yy_context) or (yy_context.input.pos = yy_varc4; yy_char_range(yy_context, "0", "9")); end and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nontermc5(yy_context)
        val = nil
        (begin
      yy_varcb = yy_context.worst_error
      yy_varcc = not(begin
      yy_varcd = yy_context.input.pos
      yy_varce = yy_nontermab(yy_context)
      yy_context.input.pos = yy_varcd
      yy_varce
    end)
      if yy_varcc
        yy_context.worst_error = yy_varcb
      else
        # NOTE: No errors were added into context but the error is still there.
        yy_context << YY_SyntaxExpectationError.new("different expression", yy_context.input.pos)
      end
      yy_varcc
    end and begin; yy_vard8 = yy_context.input.pos; (begin
      val = ""
      yy_vardl = yy_context.input.pos
      (yy_nonterme1(yy_context) and while true
      yy_vardk = yy_context.input.pos
      if not(yy_nonterme3(yy_context)) then
        yy_context.input.pos = yy_vardk
        break true
      end
    end) and begin
        yy_vardm = yy_context.input.pos
        yy_context.input.pos = yy_vardl
        val << yy_context.input.read(yy_vardm - yy_vardl).force_encoding(Encoding::UTF_8)
      end
    end and yy_nontermgh(yy_context)) or (yy_context.input.pos = yy_vard8; (begin
      val = ""
      yy_vardz = yy_context.input.pos
      (yy_string(yy_context, "`") and  begin
      while true
        ###
        yy_vardx = yy_context.input.pos
        ### Look ahead.
        yy_vardy = yy_string(yy_context, "`")
        yy_context.input.pos = yy_vardx
        break if yy_vardy
        ### Repeat one more time (if possible).
        yy_vardy = yy_char(yy_context)
        if not yy_vardy then
          yy_context.input.pos = yy_vardx
          break
        end
      end
      ### The repetition is always successful.
      true
    end  and yy_string(yy_context, "`")) and begin
        yy_vare0 = yy_context.input.pos
        yy_context.input.pos = yy_vardz
        val << yy_context.input.read(yy_vare0 - yy_vardz).force_encoding(Encoding::UTF_8)
      end
    end and yy_nontermgh(yy_context))); end) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterme1(yy_context)
        val = nil
        begin; yy_vare2 = yy_context.input.pos; yy_char_range(yy_context, "a", "z") or (yy_context.input.pos = yy_vare2; yy_char_range(yy_context, "A", "Z")) or (yy_context.input.pos = yy_vare2; yy_string(yy_context, "-")) or (yy_context.input.pos = yy_vare2; yy_string(yy_context, "_")); end and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterme3(yy_context)
        val = nil
        begin; yy_vare4 = yy_context.input.pos; yy_nonterme1(yy_context) or (yy_context.input.pos = yy_vare4; yy_char_range(yy_context, "0", "9")); end and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nonterme5(yy_context)
        val = nil
        (begin
      yy_vare7 = yy_nontermeb(yy_context)
      if yy_vare7 then
        from = yy_from_pcv(yy_vare7)
      end
      yy_vare7
    end and begin; yy_vare9 = yy_context.input.pos; yy_string(yy_context, "...") or (yy_context.input.pos = yy_vare9; yy_string(yy_context, "..")) or (yy_context.input.pos = yy_vare9; yy_string(yy_context, "\u{2026}")) or (yy_context.input.pos = yy_vare9; yy_string(yy_context, "\u{2025}")); end and yy_nontermgh(yy_context) and begin
      yy_varea = yy_nontermeb(yy_context)
      if yy_varea then
        to = yy_from_pcv(yy_varea)
      end
      yy_varea
    end and yy_nontermgh(yy_context) and begin
       raise %("#{from}" or "#{to}" is not a character) if from.length != 1 or to.length != 1 
      true
    end and begin
       val = from...to 
      true
    end) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nontermeb(yy_context)
        val = nil
        (begin; yy_varf7 = yy_context.input.pos; (yy_string(yy_context, "'") and begin
      val = ""
      yy_varfk = yy_context.input.pos
       begin
      while true
        ###
        yy_varfi = yy_context.input.pos
        ### Look ahead.
        yy_varfj = yy_string(yy_context, "'")
        yy_context.input.pos = yy_varfi
        break if yy_varfj
        ### Repeat one more time (if possible).
        yy_varfj = yy_char(yy_context)
        if not yy_varfj then
          yy_context.input.pos = yy_varfi
          break
        end
      end
      ### The repetition is always successful.
      true
    end  and begin
        yy_varfl = yy_context.input.pos
        yy_context.input.pos = yy_varfk
        val << yy_context.input.read(yy_varfl - yy_varfk).force_encoding(Encoding::UTF_8)
      end
    end and yy_string(yy_context, "'")) or (yy_context.input.pos = yy_varf7; (yy_string(yy_context, "\"") and begin
      val = ""
      yy_varfy = yy_context.input.pos
       begin
      while true
        ###
        yy_varfw = yy_context.input.pos
        ### Look ahead.
        yy_varfx = yy_string(yy_context, "\"")
        yy_context.input.pos = yy_varfw
        break if yy_varfx
        ### Repeat one more time (if possible).
        yy_varfx = yy_char(yy_context)
        if not yy_varfx then
          yy_context.input.pos = yy_varfw
          break
        end
      end
      ### The repetition is always successful.
      true
    end  and begin
        yy_varfz = yy_context.input.pos
        yy_context.input.pos = yy_varfy
        val << yy_context.input.read(yy_varfz - yy_varfy).force_encoding(Encoding::UTF_8)
      end
    end and yy_string(yy_context, "\""))) or (yy_context.input.pos = yy_varf7; (begin
      yy_varg0 = yy_nontermg1(yy_context)
      if yy_varg0 then
        code = yy_from_pcv(yy_varg0)
      end
      yy_varg0
    end and begin
       val = "" << code 
      true
    end)); end and yy_nontermgh(yy_context)) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nontermg1(yy_context)
        val = nil
        (yy_string(yy_context, "U+") and begin
      code = ""
      yy_vargf = yy_context.input.pos
      begin; yy_vargd = yy_context.input.pos; yy_char_range(yy_context, "0", "9") or (yy_context.input.pos = yy_vargd; yy_char_range(yy_context, "A", "F")); end and while true
      yy_varge = yy_context.input.pos
      if not(begin; yy_vargd = yy_context.input.pos; yy_char_range(yy_context, "0", "9") or (yy_context.input.pos = yy_vargd; yy_char_range(yy_context, "A", "F")); end) then
        yy_context.input.pos = yy_varge
        break true
      end
    end and begin
        yy_vargg = yy_context.input.pos
        yy_context.input.pos = yy_vargf
        code << yy_context.input.read(yy_vargg - yy_vargf).force_encoding(Encoding::UTF_8)
      end
    end and begin
       code  = code.to_i(16); raise %(U+#{code.to_s(16).upcase} is not supported) if code > 0x10FFFF 
      true
    end and begin
       val = code 
      true
    end) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nontermgh(yy_context)
        val = nil
        while true
      yy_vargm = yy_context.input.pos
      if not(begin; yy_vargl = yy_context.input.pos; yy_nontermgx(yy_context) or (yy_context.input.pos = yy_vargl; yy_nontermgn(yy_context)); end) then
        yy_context.input.pos = yy_vargm
        break true
      end
    end and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nontermgn(yy_context)
        val = nil
        (begin; yy_vargq = yy_context.input.pos; yy_string(yy_context, "#") or (yy_context.input.pos = yy_vargq; yy_string(yy_context, "--")); end and  begin
      while true
        ###
        yy_vargt = yy_context.input.pos
        ### Look ahead.
        yy_vargu = begin; yy_vargw = yy_context.input.pos; yy_nontermgz(yy_context) or (yy_context.input.pos = yy_vargw; yy_end?(yy_context)); end
        yy_context.input.pos = yy_vargt
        break if yy_vargu
        ### Repeat one more time (if possible).
        yy_vargu = yy_char(yy_context)
        if not yy_vargu then
          yy_context.input.pos = yy_vargt
          break
        end
      end
      ### The repetition is always successful.
      true
    end  and begin; yy_vargw = yy_context.input.pos; yy_nontermgz(yy_context) or (yy_context.input.pos = yy_vargw; yy_end?(yy_context)); end) and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nontermgx(yy_context)
        val = nil
        begin; yy_vargy = yy_context.input.pos; yy_char_range(yy_context, "\t", "\r") or (yy_context.input.pos = yy_vargy; yy_string(yy_context, " ")) or (yy_context.input.pos = yy_vargy; yy_string(yy_context, "\u{85}")) or (yy_context.input.pos = yy_vargy; yy_string(yy_context, "\u{a0}")) or (yy_context.input.pos = yy_vargy; yy_string(yy_context, "\u{1680}")) or (yy_context.input.pos = yy_vargy; yy_string(yy_context, "\u{180e}")) or (yy_context.input.pos = yy_vargy; yy_char_range(yy_context, "\u{2000}", "\u{200a}")) or (yy_context.input.pos = yy_vargy; yy_string(yy_context, "\u{2028}")) or (yy_context.input.pos = yy_vargy; yy_string(yy_context, "\u{2029}")) or (yy_context.input.pos = yy_vargy; yy_string(yy_context, "\u{202f}")) or (yy_context.input.pos = yy_vargy; yy_string(yy_context, "\u{205f}")) or (yy_context.input.pos = yy_vargy; yy_string(yy_context, "\u{3000}")); end and yy_to_pcv(val)
      end
    
      # :nodoc:
      def yy_nontermgz(yy_context)
        val = nil
        begin; yy_varh0 = yy_context.input.pos; (yy_string(yy_context, "\r") and yy_string(yy_context, "\n")) or (yy_context.input.pos = yy_varh0; yy_string(yy_context, "\r")) or (yy_context.input.pos = yy_varh0; yy_string(yy_context, "\n")) or (yy_context.input.pos = yy_varh0; yy_string(yy_context, "\u{85}")) or (yy_context.input.pos = yy_varh0; yy_string(yy_context, "\v")) or (yy_context.input.pos = yy_varh0; yy_string(yy_context, "\f")) or (yy_context.input.pos = yy_varh0; yy_string(yy_context, "\u{2028}")) or (yy_context.input.pos = yy_varh0; yy_string(yy_context, "\u{2029}")); end and yy_to_pcv(val)
      end
    
class String
  
  # returns Ruby code which evaluates to this String.
  def to_ruby_code
    self.dump
  end
  
end


class UniqueNumber
  
  begin
    @@next = 0
  end

  def self.new
    @@next.tap { @@next += 1 }
  end

end


# The value starts with "yy_var" and is lowcase.
def new_unique_variable_name
  "yy_var#{UniqueNumber.new.to_s(36)}"
end


# The value starts with "yy_nonterm" and is lowcase.
def new_unique_nonterminal_method_name
  "yy_nonterm#{UniqueNumber.new.to_s(36)}"
end


HashMap = Hash


RubyCode = String


Nonterminal = String


class Code
  
  # defines abstract method.
  def self.abstract(method)
    define_method(method) { |*args| raise %(method `#{method}' is abstract) }
  end
  
  abstract :to_s
  
  # Not overridable.
  def + other
    CodeConcatenation.new([self, other])
  end
  
  # 
  # passes every atomic Code comprising this Code and returns this Code with
  # the atomic Code-s replaced with what +block+ returns.
  # 
  def map(&block)
    block.(self)
  end
  
  # 
  # passes every atomic Code comprising this Code to +block+.
  # 
  # It returns this Code.
  # 
  # Not overridable.
  # 
  def each(&block)
    map do |part|
      block.(part)
      part
    end
  end
  
  # 
  # The same as Enumerable#reduce(initial) <tt>{ |memo, obj| block }</tt> or
  # Enumerable#reduce <tt>{ |memo, obj| block }</tt> where +obj+ is one of
  # atomic Code-s comprising this Code.
  # 
  # Not overridable.
  # 
  def reduce(initial = nil, &block)
    # TODO: Optimize.
    result = initial
    self.map { |code_part| result = block.(result, code_part); code_part }
    return result
  end
  
  # returns true if +predicate+ returns true for any atomic Code comprising
  # this code.
  def any?(&predicate)
    self.reduce(false) { |result, part| result or predicate.(part) }
  end
  
  # 
  # replaces each atomic Code which comprises this Code and is case-equal to
  # +pattern+ with +replacement+.
  # 
  def replace(pattern, replacement)
    self.map do |code_part|
      if pattern === code_part then
        replacement
      else
        code_part
      end
    end
  end
  
end


class CodeAsString < Code
  
  class << self
    
    alias [] new
    
  end
  
  def initialize(string)
    @string = string
  end
  
  def to_s
    @string
  end
  
  def inspect
    "#<CodeAsString: #{@string.inspect}>"
  end
  
end


# returns CodeAsString.
def code(string)
  CodeAsString.new(string)
end


class CodeConcatenation < Code
  
  def initialize(parts)
    @parts = parts
  end
  
  def to_s
    @parts.map { |part| part.to_s }.join
  end
  
  def + other
    # Optimization.
    CodeConcatenation.new([*@parts, other])
  end
  
  def map(&block)
    CodeConcatenation.new(@parts.map { |part| part.map(&block) })
  end
  
  def inspect
    "#<CodeConcatenation: #{@parts.map { |p| p.inspect }.join(", ")}>"
  end
  
end


class UnknownMethodCall < Code
  
  class << self
    
    alias [] new
    
  end
  
  def initialize(nonterminal, args_code, source_pos)
    @nonterminal = nonterminal
    @args_code = args_code
    @source_pos = source_pos
  end
  
  # Nonterminal associated with this UnknownMethodCall.
  attr_reader :nonterminal
  
  # Code of arguments of this call (as String).
  attr_reader :args_code
  
  # Position in source code of this UnknownMethodCall.
  attr_reader :source_pos
  
  def to_s
    raise CodeCanNotBeDetermined.new self
  end
  
  def inspect
    "#<UnknownMethodCall: @nonterminal=#{@nonterminal.inspect}>"
  end
  
end


module LazyRepeat
  
  class UnknownLookAheadCode < Code
    
    class << self
      
      alias [] new
      
    end
    
    def initialize(source_pos)
      @source_pos = source_pos
    end
    
    def to_s
      raise CodeCanNotBeDetermined.new self
    end
    
    # Position in source code associated with this UnknownLookAheadCode.
    attr_reader :source_pos
    
    def inspect
      "#<LazyRepeat::UnknownLookAheadCode>"
    end
    
  end
  
end


class CodeCanNotBeDetermined < Exception
  
  def initialize(code)
    super %(code can not be determined: #{code.inspect})
    @code = code
  end
  
  attr_reader :code
  
end


class Array
  
  alias add <<
  
end


class Rule

  def initialize()
    @need_entry_point = false
    @method_name = new_unique_nonterminal_method_name
  end

  # Nonterminal
  attr_accessor :name
  
  # Definition of method implementing this Rule.
  # 
  # It is Code.
  # 
  attr_accessor :method_definition

  # MethodName
  attr_reader :method_name

  # Default is false.
  def need_entry_point?
    @need_entry_point
  end

  # sets #need_entry_point? to true.
  def need_entry_point!
    @need_entry_point = true
  end

  def entry_point_method_name
    name
  end

end


begin
  grammar_file = ARGV[0] or abort %(Usage: ruby #{__FILE__} grammar-file)
  File.open(grammar_file) do |io|
    begin
      print(yy_parse(io))
    rescue YY_SyntaxError => e
      line, column = *(line_and_column(e.pos, io))
      STDERR.puts %(#{grammar_file}:#{line}:#{column}: error: #{e.message})
      exit 1
    end
  end
end

