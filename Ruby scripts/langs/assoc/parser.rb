REPL = {'space' => ' ', '\\n' => "\n", '\\' => ' '}

def readline line, place
  puts "Reading #{place}" if $debug
  return if line[0] == '#'
  if line[0..3] == 'use '
    line[4..-1].split.each {|file| readfile file}
	return
  end
  $program << line
end

def readfile file
  file += '.ass' unless File.exists? file		
  return if $reading.include? file
  $reading << file
  IO.read(file).split("\n").each_with_index {|line, line_number| readline line, "#{file}:#{line_number+1}"}
end