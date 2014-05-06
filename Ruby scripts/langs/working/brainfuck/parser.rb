REPL = {'space' => ' ', '\\n' => "\n", '\\' => ' '}

def readline line, place
  puts "Reading #{place}" if $debug
  #line = line.split('#')[0] || ''
  return if line[0] == '#'
  tokens = line.split ' ' || []
  puts "tokens: #{tokens}" if $debug
  if tokens[0] == 'use'
    tokens[1..-1].each {|file| readfile file}
  elsif tokens.size == 3 && $head.key?(tokens[0]) && tokens[1] == 'in' 
    $head[tokens[0]] = tokens[2] if $head.key?(tokens[0]) && tokens[1] == 'in'
    $head_line[tokens[0]] = place
  elsif (2..4) === tokens.size && tokens[0][-1] = ':'
    v = tokens[0][0...-1]
    tokens[1] = char tokens[1]
    tokens[3] ||= tokens[2] ||= v
    $vertex[v] = tokens[1..3]
    $vertex_line[v] = place
  else
    puts "Line considered to be comment" if $debug
  end
end

def readfile file
  file += '.gr' unless File.exists? file		
  return if $reading.include? file
  $reading << file
  IO.read(file).split("\n").each_with_index {|line, line_number| readline line, "#{file}:#{line_number+1}"}
end