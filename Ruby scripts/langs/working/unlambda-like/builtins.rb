class Fun
  def apply x
	  $apply_counter += 1
		puts "applying #{self} to #{x}" if $debug
		apply_internal x
	end
end

class K1 < Fun
  def initialize x
	  @x = x
	end
	def apply_internal y
		$stack.push @x
	end
	def to_s
	  "k(#{@x})"
	end
end

class K < Fun
  def apply_internal x
		$stack.push K1.new(x)
	end
	def to_s
	  "k"
	end	
end

class S2 < Fun
  def initialize x,y
	  @x,@y = x,y
	end
	def apply_internal z
		#raise 'deep stack' if $stack_level > $max_stack_level
    ['`', '`', @x, z, '`', @y, z].reverse.each {|el| $queue.unshift el}
	end
	def to_s
	  "s(#{@x}, #{@y})"
	end
end

class S1 < Fun
  def initialize x
	  @x = x
	end
	def apply_internal y
		$stack.push S2.new(@x,y)
	end
	def to_s
	  "s(#{@x})"
	end
end

class S < Fun
  def apply_internal x
		$stack.push S1.new(x)
	end
	def to_s
	  "s"
	end		
end

class P < Fun
  def initialize c
	  @c = c
	end
	def apply_internal y
		print @c unless $silence
    $stack.push y
	end
	def to_s
	  "p(#{@c})"
	end		
end

class R < Fun
  def initialize c
	  @c = c
	end
	def apply_internal y
		$cur_char = STDIN.getc unless $cur_char
		if $cur_char == @c 
		  $cur_char = nil
			$stack.push y
      return
		end
		$stack.push S2.new(K.new,K.new)
	end
	def to_s
	  "r(#{@c})"
	end		
end

class X < Fun
  def initialize name, args = []
	  @name, @args = name, args
	end
	def apply_internal x
		res = X.new @name, @args+[x]
		$applies << res.to_s
		$stack.push res
	end
	def to_s
	  "#{@name}" + (@args.size > 0 ? "(#{@args.join(', ')})" : '')
	end
end