require_relative 'parser'

$a = Hash.new 0
$l = 0
$x = 0
$p = 0
$code = ''

def command
  $code[$p]
end

def run 
  stack = []
  $p = 0
  while command
    case command
      when '>' then $x += 1
      when '^' then $x = $a[$x]
      when '*' then $l = $x
      when '!' then $a[$x] = $l
      when '.' then putc $x.chr
      when '?' then $x = STDIN.getc.ord unless STDIN.eof?
      when '[' then 
        if $x == $l 
          deep = 1
          while deep > 0
            $p += 1
            deep += 1 if command == '['
            deep -= 1 if command == ']'
          end
        else
          stack << $p
        end
      when ']' then 
        if $x != $l
          $p = stack[-1]
        else
          stack.pop
        end
      else #comment
    end
    $p += 1 
    print_state if $debug
  end
end

def print_state
  puts
  puts "a = #{$a}"
  puts "l = #{$l}"
  puts "x = #{$x}"
  puts "code = #{$code[0...$p]}(#{$code[$p]})#{$code[$p+1..-1]}"
end

def run_program file
  readfile file
  run
end