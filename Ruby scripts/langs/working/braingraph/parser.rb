$funs = {}
$last = $code
$reading = []

def parse tokens
  res = ''
  tokens.each {|t| res << ($funs[t] || t)}
  res
end

def readline line, place
  puts "Reading #{place}" if $debug
  #line = line.split('#')[0] || ''
  return if line[0] == '#'
  tokens = line.split ' ' || []
  puts "tokens: #{tokens}" if $debug
  if tokens[0] == 'use'
    tokens[1..-1].each {|file| readfile file}
    return
  end 
  if tokens[1] == '='
    $last = $funs[tokens[0]] = ''
    tokens.shift 2
  else
    $last = $code
  end
  $last << parse(tokens)
end

def readfile file
  file += '.bg' unless File.exists? file		
  return if $reading.include? file
  $reading << file
  IO.read(file).split("\n").each_with_index {|line, line_number| readline line, "#{file}:#{line_number+1}"}
end