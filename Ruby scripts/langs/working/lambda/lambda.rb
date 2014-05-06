class Lambda
  def initialize arg = nil, tokens = []
    @arg, @tokens, @deep = arg, tokens, 0
  end
  
  attr_accessor :tokens
  attr_accessor :deep
  attr_accessor :arg
  
  def apply x
	  puts "Applying #{self} on #{x}" if $debug
		puts "Tokens are #{@tokens}" if $debug
    res = ['('].concat sub(arg,x) << ')'
		puts "Res is #{res}" if $debug
		res
  end 

  def sub x,y 
  	@tokens.map do |token| 
		  case 
			  when token == x then y
		    when token.class == Lambda && token.arg != x 
					res = Lambda.new(token.arg,token.sub(x,y))
					if @name && @tokens.size == 1
					  puts "Naming #{self}(#{y}) (tokens #{res.tokens}) as #{@name}(#{y})" if $debug
						res.named("#{@name}(#{y})") 
					end
					res
			  else token
			end
		end
  end
	
	def named name
	  @name = name
		$named_lambdas[name] = self
	end
	
	def to_s
	  return '<empty_string>' if @name == ''
		@name || "(\\#{arg} #{@tokens.join(' ')})"
	end
end