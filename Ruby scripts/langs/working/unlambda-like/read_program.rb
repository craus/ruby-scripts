def execute file, line_number, line
	#puts "reading (#{file}:#{line_number+1})"
  return if line[0] == '#'
	tokens = line.split
	return if tokens.size == 0
	puts "tokens: #{tokens}" if DEBUG
	if tokens[0] == 'use'
	  read tokens[1..-1] 
		return
	end
	if (tokens[0] == 'debug')	  
	end
	@last = (tokens[1] == '=' ? tokens[2..-1] : tokens).join(' ')
	
	if tokens[1] == '='	
		#puts "added function #{tokens[0]} as \"#{@last.join(' ')}\""
		@functions[tokens[0]] = @last
	else
	  @main << @last
	end
end

def read files
  files.each do |file|
		next if @reading.include? file
		@reading << file
		file += '.fz' unless File.exists? file		
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