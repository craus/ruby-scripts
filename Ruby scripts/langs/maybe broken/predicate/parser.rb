require_relative 'models'

$data = []
$reading = []
$consts = []
$vars = []

def parse tokens
  res = ''
  tokens.each {|t| res << ($funs[t] || t)}
  res
end

def readline line, place
  puts "Reading #{place}" if $debug
  line = line.split('#')[0] || ''
  tokens = line.split ' ' || []
  puts "tokens: #{tokens}" if $debug
	case tokens[0]
	  when 'use' then tokens[1..-1].each {|file| readfile file}
		when 'const' then $consts += tokens[1..-1]
		when 'var' then $vars += tokens[1..-1]
		else $data << Disjunct.new(tokens)
	end	
end

def readfile file
  file += '.pr' unless File.exists? file		
  return if $reading.include? file
  $reading << file
  IO.read(file).split("\n").each_with_index {|line, line_number| readline line, "#{file}:#{line_number+1}"}
end