require_relative 'parser'

$reading = []
$program = []
$data = {}
$reading_buffer = ''
$writing_buffer = ''

def calc_write expression
  expression.strip!
  if expression.include? ' '
    expression.strip.split.map{|part| calc_value part}
  else
    expression
  end
end

def calc_value expression
  get_value calc_write(expression)
end

def get_value cell
  result = $data[cell] || (cell.class == Array ? nil : cell) || 'nil'
  puts "get_value(#{cell}) = #{result}" if $debug
  result
end

def set_value cell, value
  puts "set_value(#{cell}, #{value})" if $debug
  $data[cell] = value
end

def set_labels
  $program.each_with_index do |line, index|
    if line.include? ':'
      label, command = line.split ':'
      set_value calc_write(label), index
      $program[index] = command.strip
    end
  end
end

def unknown command
  raise "Unknown command '#{command}'"
end

def no_line_associated expression
  raise "No line associated to '#{expression}'"
end

def read
  if $binary_input
    c = STDIN.eof? ? 'nil' : STDIN.getc
    c = 'nil' if !'01'.include? c
    c
  else
    $reading_buffer = STDIN.getc.ord.to_s(2).rjust(8,'0') if $reading_buffer.empty? && !STDIN.eof?
    value = $reading_buffer[0]
    $reading_buffer[0] = ''
    value || 'nil'
  end
end

def write value
  return if value == 'nil'
  if $binary_output
    putc value
  else
    $writing_buffer << value
    if $writing_buffer.size == 8
      putc $writing_buffer.to_i(2).chr
      $writing_buffer = ''
    end
  end
end

def new_object
  Object.new
end

def run
  line = 0
  while true
    command = $program[line]
    puts "Executing '#{command}'" if $debug
    next_line = line + 1
    case 
      when /read (?<expression>.+)/ =~ command then set_value calc_write(expression), read
      when /write (?<expression>.+)/ =~ command then write calc_value(expression)
      when /goto (?<expression>.+)/ =~ command then next_line = calc_value(expression)
      when /(?<left>.+)=(?<right>.+)/ =~ command then set_value calc_write(left), calc_value(right)
      when /new (?<expression>.+)/ =~ command then set_value calc_write(expression), new_object
      when /exit/ =~ command then break
      else unknown(command)
    end
    no_line_associated(expression) if next_line.class != Fixnum 
    line = next_line
    p $data if $debug
    break if line == $program.size 
  end
end

def run_program file
  readfile file
  p $program if $debug
  set_labels
  puts 'Labels set' if $debug
  p $program if $debug
  p $data if $debug
  run
end