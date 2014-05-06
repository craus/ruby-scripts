require_relative 'parser'
require_relative 'lambda'
require_relative 'builtins'

$parts = {}
$left = []
$right = []
$current_char = nil
$last = nil
$applies = 0
$move = 0
$max_move = 10**10

$named_lambdas = {}

SPECIALS = %w[( ) ` \\]

def print_stack
  puts "#{$left.join(' ')} | #{$right.reverse.join(' ')}"
end

def run
  loop do
		if $left[-2].class <= Lambda && $left[-1].class <= Lambda
		  $right.concat $left[-2].apply($left[-1]).reverse
			$left.pop 2
			$left.pop if $left[-1] == '`' 
	  elsif $left[-3] == '(' && $left[-1] == ')'
		  $left[-3..-1] = $left[-2]
		elsif $right.size > 0
		  $left << $right.pop
		else 
		  break
		end	
    print_stack if $debug
		$move += 1
		raise "Max move!" if $move == $max_move
  end
end

def print_result
  puts
  puts "Result: #{$left[0]}"
  puts "Applies: #{$applies}"
end

def add_builtins
  $parts['.\s'] = Write.new ' '
  $parts['.\n'] = Write.new "\n"
  $parts['?\s'] = Read.new ' '
  $parts['?\n'] = Read.new "\n"
	$parts['?nil'] = Read.new nil
	$parts['@'] = Move.new
  SPECIALS.each{|x| $parts[x] = x}
  0.upto(255) do |i| 
	  c = i.chr
    $parts[".#{c}"] = Write.new c
    $parts["?#{c}"] = Read.new c
  end
end

def print_program p
  tab = ""
	p.each do |token|
		tab = tab[0...-2] if token == ')'
	  puts "#{tab}#{token}"
		tab << '  ' if token == '('
	end
end

def run_program file
  $parts['main'] = $last = []
  readfile file
  add_builtins
  $right = link('main').reverse
  if $debug
    puts "Named Lambdas:"
    $named_lambdas.each do | name, lambda |
		  puts "#{name} : \\#{lambda.arg} #{lambda.tokens.join(' ')}"
		end
    puts "---"
  end
  if $debug
  	puts "Program:"
	  print_program($left + ["|"] + $right.reverse)
	end
	
  run
  print_result if $result 
end