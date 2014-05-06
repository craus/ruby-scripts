require_relative 'parser'

$reading = []
$functions = {}
$last_function
$reading_buffer = ''
$writing_buffer = ''

def char_to_obj c
  case c
    when '0' then nil
    when '1' then [nil,nil]
    else nil
  end
end

def obj_to_char obj
  obj.nil? ? '0' : '1'
end

def read
  if $binary_input
    c = STDIN.eof? ? nil : STDIN.getc
    char_to_obj c
  else
    $reading_buffer = STDIN.getc.ord.to_s(2).rjust(8,'0') if $reading_buffer.empty? && !STDIN.eof?
    value = $reading_buffer[0]
    $reading_buffer[0] = ''
    char_to_obj value
  end
end

def write value
  puts "write(#{value.inspect})" if $debug
  if $binary_output
    putc obj_to_char(value)
  else
    $writing_buffer << obj_to_char(value)
    if $writing_buffer.size == 8
      putc $writing_buffer.to_i(2).chr
      $writing_buffer = ''
    end
  end
end

class LangException < Exception
end

def no_such_function name
  raise LangException, "No such function: #{name}", caller
end

STD_ARITIES = {nil: 0, pair: 2, first: 1, second: 1, if: 3, bin: 0, bout: 1, eof: 0}

def arity f
  STD_ARITIES[f.to_sym] || $functions[f][:args].size rescue no_such_function f
end

def calc f, args
  puts "calc(#{f}, #{args})" if $debug
  result = case
    when f == 'nil' then nil
    when f == 'pair' then [args[0], args[1]]
    when f == 'first' then args[0][0] rescue raise LangException, "Called first(nil)", caller
    when f == 'second' then args[0][1] rescue raise LangException, "Called second(nil)", caller
    when f == 'if' then args[args[0].nil? ? 2 : 1]
    when f == 'bin' then read
    when f == 'bout' then write args[0]; [nil,nil]
    when f == 'eof' then STDIN.eof? ? nil : [nil,nil]
    when $functions[f] then calc_user_function $functions[f], args
    else no_such_function f
  end
  puts "calc(#{f}, #{args}) = #{result.inspect}" if $debug
  result
end

def calc_user_function f, args
  body = f[:body]
  args = (0...f[:args].size).to_a.inject({}){|h, i| h[f[:args][i]] = args[i]; h}
  result, last_position = find_value body, args, 0
  result
end

def find_value tokens, context, position
  #puts "find_value(#{tokens}, #{context}, #{position})" if $debug
  f = tokens[position]
  return [context[f], position+1] if context.has_key?(f)
  args = []
  position += 1
  arity(f).times do
    #puts "find_value #{tokens}, #{context}, #{position.inspect}" if $debug
    arg, position = find_value tokens, context, position
    #puts "position now = #{position}" if $debug 
    args << arg
  end
  #puts "find_value(#{tokens}, #{context}, #{position}): args = #{args}" if $debug
  result = [calc(f,args), position]
  #puts "find_value(#{tokens}, #{context}, #{position}) = #{result}" if $debug
  result
end

def run_program file
  readfile file
  p $functions if $debug
  result = calc 'main', []
  p result if $result
rescue LangException => e
  puts "Lang error: #{e.message}"
end