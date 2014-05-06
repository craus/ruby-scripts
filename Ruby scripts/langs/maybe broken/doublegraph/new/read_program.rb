def analyze tokens
	
	if tokens[0][-1] == ':'
		
end

def execute file, line_number, line
	puts "reading (#{file}:#{line_number+1})" if $debug
	return if line[0] == '#'
	tokens = line.split
	return if tokens.size == 0
	puts "tokens: #{tokens}" if DEBUG
	if tokens[0] == 'use'
		read tokens[1..-1] 
		return
	end
	if (tokens[0] == 'debug')
		return
	end
	
	analyze tokens
end

def read files
  files.each do |file|
		next if @reading.include? file
		@reading << file
		file += '.dg' unless File.exists? file		
		text = IO.read(file).split("\n")
		text.each_with_index { |line, index| execute file, index, line }
	end
end

def read_program
	unless ARGV[0]
		puts 'Please give source code file name as the first parameter'
		exit
	end
	read [ARGV[0]]
end