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

class Expression
  attr_accessor :function, :args
  def initialize function, args
    @function, @args = function, args
  end
end

class LangException < Exception
end

def no_such_function name
  raise LangException, "No such function: #{name.inspect}", caller
end

STD_ARITIES = {nil: 0, pair: 2, first: 1, second: 1, if: 3, bin: 0, bout: 1, eof: 0}

def arity f
  STD_ARITIES[f.to_sym] || $functions[f][:args].size rescue no_such_function f
end

def calc_function name, args
  f = $functions[name]
  no_such_function name if !f
  body = f[:body]
  args = (0...f[:args].size).to_a.inject({}){|h, i| h[f[:args][i]] = args[i]; h}
  puts "calc_function #{name}(#{f[:args]}): #{args}" if $debug
  result = calc substitute(body, args)  
  puts "calc_function #{name}(#{f[:args]}): #{args} = #{result}" if $debug
  result
end

def substitute tree, hash
  tree.class == String ? hash[tree] : Expression.new(tree.function, tree.args.map{|x| substitute(x,hash)})
end

def calc expression
  puts "calc(#{expression})" if $debug
  return expression if expression.class != Expression
  result = case
    when expression.function == 'nil' then nil
    when expression.function == 'pair' then [calc(expression.args[0]), calc(expression.args[1])]
    when expression.function == 'first' then (calc expression.args[0])[0] rescue raise LangException, "Called first(nil)", caller
    when expression.function == 'second' then (calc expression.args[0])[1] rescue raise LangException, "Called second(nil)", caller
    when expression.function == 'if' then calc expression.args[(calc expression.args[0]).nil? ? 2 : 1]
    when expression.function == 'bin' then read
    when expression.function == 'bout' then write calc(expression.args[0]); [nil,nil]
    when expression.function == 'eof' then eof ? [nil,nil] : nil
    when $functions[expression.function] then calc_function expression.function, expression.args.map{|arg| calc(arg)}
    else no_such_function expression.function
  end  
  puts "calc(#{expression}) = #{result.inspect}" if $debug  
  result
end

def tree tokens, context, position
  #puts "tree(#{tokens}, #{context}, #{position})" if $debug
  f = tokens[position]
  return [f, position+1] if context.include?(f)
  args = []
  position += 1
  arity(f).times do
    #puts "find_value #{tokens}, #{context}, #{position.inspect}" if $debug
    arg, position = tree tokens, context, position
    #puts "position now = #{position}" if $debug 
    args << arg
  end
  #puts "find_value(#{tokens}, #{context}, #{position}): args = #{args}" if $debug
  result = [Expression.new(f,args), position]
  #puts "find_value(#{tokens}, #{context}, #{position}) = #{result}" if $debug
  result
end

def parse_bodies
  $functions.each_value do |value|
    value[:body] = tree(value[:body], value[:args], 0)[0]
  end
end

def run_program file
  readfile file
  #puts $functions.map{|k,v| "#{k} => #{v}"}.join("\n") if $debug
  parse_bodies
  puts $functions.map{|k,v| "#{k} => #{v}"}.join("\n") if $debug
  result = calc_function 'main', []
  p result if $result
rescue LangException => e
  puts "Lang error: #{e.message}"
end