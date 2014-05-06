def readline line, place
  puts "Reading #{place}" if $debug
  return if line[0] == '#'
  if line[0..3] == 'use '
    line[4..-1].split.each {|file| readfile file}
	return
  end
  tokens = line.split
  if tokens.include? 'is'
    $last_function = {args: tokens[1...tokens.index('is')], body: tokens[tokens.index('is')+1..-1]}
    $functions[tokens[0]] = $last_function
  else
    $last_function[:body] += tokens if $last_function
  end
  #puts "readline done. $functions = #{$functions}" if $debug
end

def readfile file
  file += '.fz' unless File.exists? file		
  return if $reading.include? file
  $reading << file
  IO.read(file).split("\n").each_with_index {|line, line_number| readline line, "#{file}:#{line_number+1}"}
end