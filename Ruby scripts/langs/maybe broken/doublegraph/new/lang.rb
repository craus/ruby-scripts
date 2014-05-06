def line_to_s name, line
  "#{name}:\n  " + line.join("\n  ")
end

require_relative 'read_program'

@reading = []
@last = nil
$debug = ARGV.include? 'd'
DEBUG = false
@warnings = []
@strict = !ARGV.include?('u')
$silence = false

$symbols = {}
$back_symbols = {}
$a = Hash.new(Hash.new nil)

def run_program
	cur = 'begin'
	while cur != 'end' 
		case $a[cur]['command']
			when 'read'
				$a[cur]['result'] = (STDIN.eof? ? 'eof' : $back_symbols[STDIN.getc])
			when 'write'
				calc $a[cur]['arg']
				putc $symbols[$a[cur]['arg']]
			when 'set'
				%w(x y z).each {|x| calc $a[cur][x]}
				$a[$a[cur][x]][$a[cur][y]] = $a[cur][z]
		end
		cur = $a[cur]['next']
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
		puts "main(#{@xs.join(', ')}) = #{$stack[0]}"
		puts line_to_s 'stack', $stack
		puts "Applies: #{$apply_counter}"
		puts line_to_s 'applies', $applies
		puts "Code: #{@code.join}"
	end

	puts line_to_s 'warnings', @warnings.uniq if @warnings.size > 0
end


