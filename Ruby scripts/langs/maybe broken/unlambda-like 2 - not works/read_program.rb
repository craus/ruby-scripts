def read_line file, line_number, line
	#puts "reading (#{file}:#{line_number+1})"
  return if line[0] == '#' # comments
	tokens = line.split
	return if tokens.size == 0
	puts "tokens: #{tokens}" if DEBUG
	if tokens[0] == 'use'
	  read tokens[1..-1] 
		return
	end
	if (tokens[0] == 'debug')	  
	end
	
	if (left = tokens.index('=')).nil?
		@main += tokens
    #puts "added function #{tokens[0]} as \"#{@last.join(' ')}\""
	else	  
		@functions[tokens[0]] = @last
	end
end

def read_files files
  files.each do |file|
		next if @reading.include? file
		@reading << file
		file += '.fz' unless File.exists? file		
		text = IO.read(file).split("\n")
		text.each_with_index { |line, line_number| read_line file, line_number, line }
	end
end

def read_program
	unless ARGV[0]
		puts 'Please give source code file name as the first parameter'
		exit
	end
	read_files [ARGV[0]]
end