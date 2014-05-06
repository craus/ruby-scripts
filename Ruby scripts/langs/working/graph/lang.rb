require_relative 'parser'

$reading = []

$head = {'code' => nil, 'data' => nil, 'label' => nil}
$vertex = {}
$right = true
$counter = 0
$step = 1
$head_line = {}
$vertex_line = {}

def char c
  if REPL.key? c
    #puts "#{c} considered as #{REPL[c]}" if $debug
    c = REPL[c] 
  end
    
  c = c[1..-1].to_i.chr if c.size > 1 && c[0] == '\\'
  c
end

def run
  while true
    puts "\nStep #{$step}" if $debug
    puts "Command is #{$vertex[$head['code']][0]}" if $debug
    case $vertex[$head['code']][0] 
      when 'T' then $right = !$right
      when 'M' then $head['data'] = $vertex[$head['data']][$right ? 1 : 2]
      when 'I' then $vertex[$head['data']][0] = STDIN.getc unless STDIN.eof?
      when 'O' then putc char($vertex[$head['data']][0])
      when 'R' then $vertex[$head['label']][$right ? 1 : 2] = $vertex[$head['data']]
      when 'L' then $head['label'] = $head['data']
      when 'W' then $vertex[$head['data']][0] = $vertex[$head['label']][0]
      when 'N' 
        $vertex[$counter+=1] = $vertex[$head['data']][0], $head[$right ? 'label' : 'data'], $head[$right ? 'data' : 'label']
        $vertex[$head['data']][$right ? 1 : 2] = $counter     
        $head['data'] = $counter
        puts "new vertex" if $debug
      else break
    end
    $step += 1
    collect_garbage
    $head['code'] = $vertex[$head['code']][$vertex[$head['data']][0] != $vertex[$head['label']][0] ? 1 : 2]
    print_graph if $debug
  end
end

def collect_garbage
end

def print_result
  print_graph
end

def print_graph
  puts "Graph:"
  $head.each {|head, pos| puts "#{head} in #{pos}"}
  puts $right ? 'right' : 'left' 
  $vertex.each {|name, data| puts "#{name}: #{data.join(' ')}"}
end

def check_vertex v, line
  raise "Unknown vertex #{v} at #{line}" unless $vertex[v]
end

def check_graph
  $vertex.each {|name, data| data[1..2].each{|v| check_vertex v, $vertex_line[name]}}
  $head.each do |h,v|
    raise "Head '#{h}' has not been placed" if v.nil?
    check_vertex v, $head_line[h]
  end
end

def run_program file
  readfile file
  
  print_graph if $debug
  
  begin
    check_graph
  rescue => e
    puts "Graph incorrect:"
    puts e
    exit
  end
  
  begin
    run
  rescue => e
    puts "Exception occures: #{e}"
    puts "#{e.backtrace}"
    puts "Step ##{$step}"
    print_graph    
  end
  
  print_result if $result 
end