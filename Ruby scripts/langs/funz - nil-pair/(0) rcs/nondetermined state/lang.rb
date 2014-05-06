require_relative 'parser'

$reading = []
$functions = {}
$last_function
$reading_buffer = ''
$writing_buffer = ''
$stack = []

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
  attr_accessor :function, :args, :value
  
  def initialize *params
    @function, @args = params
    @value = :undefined
  end
  
  def self.const x
    e = Expression.new
    e.value = x
    e
  end
  
  def calc
    debug "e: #{self}" 
    if @value != :undefined
      undebug "#{self} = #{@value}" 
      return @value
    end
    result = case
      when function == 'nil' then nil
      when function == 'pair' then args.map(&:calc)
      when function == 'first' then p = args[0].calc; raise LangException, "Called first(#{p})", caller[0] if p.nil?; p[0]
      when function == 'second' then p = args[0].calc; raise LangException, "Called second(p)", caller[0] if p.nil?; p[1]
      when function == 'if' then args[args[0].calc.nil? ? 2 : 1].calc
      when function == 'bin' then read
      when function == 'bout' then write args[0].calc; [nil,nil]
      when function == 'eof' then eof ? [nil,nil] : nil
      when $functions[function] then calc_function function, args
      else no_such_function function
    end  
    undebug "#{self} = #{result}" 
    @value = result
    result
  end
  
  def to_s
    if @value != :undefined
      "const #{@value.inspect}"
    else
      "#{@function}#{"(#{@args.join(', ')})" if @args.size > 0}"
    end 
  end
end

class LangException < Exception
  def initialize message
    super "#{message}:\n#{$stack.reverse.join "\n"}"
  end
end

def no_such_function name
  raise LangException, "No such function: #{name.inspect}", caller
end

STD_ARITIES = {nil: 0, pair: 2, first: 1, second: 1, if: 3, bin: 0, bout: 1, eof: 0}

def arity f
  STD_ARITIES[f.to_sym] || $functions[f][:args].size rescue no_such_function f
end

def debug s
  $stack << s
  return if !$debug
  puts s
end

def undebug s
  $stack.pop
  return if !$debug
  puts s
end

def calc_function name, args
  f = $functions[name]
  no_such_function name if !f
  body = f[:body]
  args = (0...f[:args].size).to_a.inject({}){|h, i| h[f[:args][i]] = args[i]; h}
  debug "#{name}(#{args.map{|x,y| "#{x} = #{y}"}.join ', '})" 
  result = substitute(body, args).calc
  undebug "#{name}(#{args.map{|x,y| "#{x} = #{y}"}.join ', '}) = #{result}" 
  result
end

def substitute tree, hash
  tree.class == String ? hash[tree] : Expression.new(tree.function, tree.args.map{|x| substitute(x,hash)})
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
  parse_bodies
  result = calc_function 'main', []
  p result if $result
rescue LangException => e
  puts "Lang error: #{e.message}"
end