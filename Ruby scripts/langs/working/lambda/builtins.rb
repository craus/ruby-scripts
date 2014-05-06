require_relative 'lambda'

class Com
  def self.escape char
	  case char
		  when "\n" then '\n'
			when ' ' then '\s'
			when "\t" then '\t'
			else char
		end
	end
end

class Write < Lambda
  def initialize c
    @c = c    
  end
  
  def apply x
    putc @c
		[x]
  end
  
  def to_s
    ".#{Com.escape @c}"
  end
end

class Move < Lambda
  def apply x
	  $current_char = STDIN.eof? ? nil : STDIN.getc
		[x]
	end
	
	def to_s
	  '@'
	end
end

class Read < Lambda
  def initialize c
    @c = c    
  end
  
  def apply x
		[Lambda.new('y', [$current_char == @c ? x : 'y']).named("k(#{x})")]
  end

  def to_s
    "?#{Com.escape @c}"
  end
end