

def run program
  pos = 0
  cur = 0
  tape = Hash.new 0
  stack = []
  while pos < program.size
    command = program[pos]
    case command
      when '>' then cur += 1
      when '<' then cur -= 1
      when '+' then tape[cur] = (tape[cur] + 1) % 256
      when '-' then tape[cur] = (tape[cur] - 1) % 256
      when '.' then putc tape[cur].chr
      when '?' then tape[cur] = STDIN.getc.ord unless STDIN.eof?
      when '[' then 
        if tape[cur] == 0 
          deep = 1
          while deep > 0
            pos += 1
            deep += 1 if program[pos] == '['
            deep -= 1 if program[pos] == ']'
          end
        else
          stack << pos
        end
      when ']' then 
        if tape[cur] != 0
          pos = stack[-1]
        else
          stack.pop
        end
      else #comment
    end
    pos += 1    
  end
end

def run_program file
  file += '.bf' unless File.exists? file		
  run IO.read(file)
end