def line_to_s name, line
  "#{name}:\n  " + line.join("\n  ")
end

require_relative 'read_program'
require_relative 'builtins'

@reading = []
@last = nil
@functions = {}
@stack = []
@main = []
$debug = ARGV.include? 'd'
$apply_counter = 0
DEBUG = false
@xs = []
@cur_char = nil
@builtins = %w(s k r _ ` ~ #)
$applies = []
@code = []
@warnings = []
@strict = !ARGV.include?('u')
$silence = false
$stack_level = 0
$max_stack_level = 52

def fun in_fun = 'program', token
  return S.new if token == 's'
	return K.new if token == 'k'
	return P.new ' ' if token == '_'
	return P.new "\n" if token == 'r'
	return P.new token[1] if token[0] == '.'
	return R.new ' ' if token == '~'
	return R.new "\n" if token == '#'
	return R.new token[1] if token[0] == '?'
	return '`' if token == '`'
	nil
end

def push_fun fun
  @code.push fun unless fun.class == X
	@stack.push fun
	while (@stack.size > 2 && @stack[-3] == '`' || @stack.size == 2) && @stack[-2] != '`' && @stack[-1] != '`' 
	  f,g = @stack.pop 2
		@stack.pop
		@stack.push f.apply(g)
	end
end

def push token  
	if f = fun(token)
	  push_fun f
	elsif @functions.key? token 
    run token, @functions[token], @strict
	else
	  raise "no such function: #{token}"
	end
end

def add_applies tokens
	cnt = tokens.count '`'
	cnto = tokens.size - cnt - 1
	(cnto-cnt).times {tokens.unshift '`'}
end

def good s
  @builtins.any?{|x| x.start_with? s} ||
  @functions.keys.any?{|x| x.start_with? s} ||
	(s[0] == '.' || s[0] == '?') && s.size <= 2
end

def check name, source, tokens, strict
  deep = 0
	cnt = 0
	tokens.each do |token|
		if token == '`' 
		  deep += 1
		else
		  deep -= 1
		end
		cnt += 1 if deep < 0		
	end
	if cnt != 1
	  e = "#{name} (\"#{source}\") is incorrect!"
		if strict
		  raise e
		else
		  @warnings.push e
		end
	end
	  
end

def run name, line, strict = true
  puts "running #{name} : #{line}" if $debug
	tokens = []
	line = line.dup
	source = line.dup
	while line.size>0
	  line.strip!
	  len = 1
		#puts "line = #{line.inspect}"
		while len <= line.size && good(line[0,len])
		  len += 1
		end
		len -= 1
		raise "bad line: \"#{line}\"" if len == 0
		tokens.push line[0,len]
		line[0,len] = ''
	end
	puts "name = #{name}"
	puts "tokens = #{tokens}"
	add_applies tokens
	puts "tokens = #{tokens}"
	#check name, source, tokens, strict
	#puts "tokens = #{tokens}"
	tokens.each {|token| push token}
end

def run_program
	run 'main', @main.join(' '), false
	%w(x y z w v q r t).each do |x|
		if x=='x' || @stack.size>1 || @stack[0].class != X
			push_fun X.new(x) 
			@xs.push x
		end
	end
end

#unused
def run_function text = @functions[name].join(' ')
	@stack.clear
	@xs.clear
	$applies.clear
	$apply_counter = 0
	$stack_level = 0
	begin
		run 'fun', text, true
		%w(x y z w v q).each do |x|
			if x=='x' || @stack.size>1 || @stack[0].class != X
				push_fun X.new(x) 
				@xs.push x
			end
		end

		return [@xs.dup, @stack[0].dup, $applies.dup, $apply_counter]
	rescue
	  return nil
	end
end

def interpret
	read_program
	if $debug 
		puts "functions:" 
		@functions.each do |k,v|
			puts "#{k} = #{v}"
		end
	end
	run_program

	if ARGV.include? 'r' 
		puts
		puts "main = #{@main.join ' '}"
		puts "main(#{@xs.join(', ')}) = #{@stack[0]}"
		puts line_to_s 'stack', @stack
		puts "Applies: #{$apply_counter}"
		puts line_to_s 'applies', $applies
		puts "Code: #{@code.join}"
	end

	puts line_to_s 'warnings', @warnings.uniq if @warnings.size > 0
end


