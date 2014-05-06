require_relative 'lambda'
require_relative 'builtins'

def readline file, line_number, line
  tokens = line.split ' '
  return if tokens[0] && tokens[0][0] == '#'
  if tokens[0] == 'use'
    tokens[1..-1].each {|file| readfile file}
    return
  end
  left = tokens.index '='
  raise "= not in place in '#{line}' (tokens are #{tokens})" if left && left != 1  
  if left
    $parts[tokens[0]] = $last = []
    tokens.shift 2
  end
  $last = $last.concat tokens
end

$reading = []

def readfile file
  file += '.lb' unless File.exists? file		
  return if $reading.include? file
  $reading << file
  $last = $parts['main']
  IO.read(file).split("\n").each_with_index {|line, line_number| readline file, line_number, line}
  $last = $parts['main']
end

def link part_name, lambdas = [Lambda.new]
  part = $parts[part_name]
	mylambda = nil
	part.each do |word|
    word = word.dup
		puts "Parsing: '#{word}'" if $parser_debug
		while word.size > 0
			best, best_len = nil, 0

      best_arg = lambdas.map(&:arg).select{|a| word.start_with? a}.max_by{|a| a.size}
			best,best_len = best_arg,best_arg.size if best_arg!=nil && best_arg.size > best_len 

			best_part = $parts.select{|f| word.start_with? f}.max_by{|f| f[0].size}
      best,best_len,best_part_name = best_part[1],best_part[0].size,best_part[0] if best_part!=nil && best_part[0].size > best_len 
      
      raise "bad string: #{word}" if best.nil?
      
			puts "Found #{best} in #{word}" if $parser_debug
      word[0...best_len] = ''
			
      if best == "\\"
        arg = word.split("\\")[0]
        word[0...arg.size] = ''
        lambda = Lambda.new arg
				mylambda ||= lambda
        lambdas[-1].tokens << lambda
        lambdas << lambda
      elsif best == '('
        lambdas[-1].deep += 1
        lambdas[-1].tokens << best
      elsif best == ')'
        lambdas.pop while lambdas[-1].deep == 0
        lambdas[-1].deep -= 1
        lambdas[-1].tokens << best
      elsif best.class == Array
        link best_part_name, lambdas
      else
        lambdas[-1].tokens << best
		  end
			
			puts "Lambdas = #{lambdas}" if $parser_debug
    end       		
  end
	mylambda.named(part_name) if mylambda && !lambdas.include?(mylambda)
  lambdas[0].tokens  
end
