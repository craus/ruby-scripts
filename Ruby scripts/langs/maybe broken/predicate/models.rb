class Disjunct
  attr_accessor :literas
	attr_accessor :target
	
	def initialize tokens
	  litera = Litera.new
		after_if = false
		@literas = []
		@target = false
		tokens.each do |token|
		  case token
			  when 'if' then after_if = true; @literas << litera; litera = Litera.new(!after_if)
				when 'not' then litera.sign ^= 1
				when 'and' then @literas << litera; litera = Litera.new(!after_if)
				when '?' then @target = true
				else litera.tokens << token
			end
		end
		@literas << litera
	end
	
	def to_s
	  "#{'-> ' if @target}" + @literas.join(' or ')
	end
end

class Litera
  attr_accessor :tokens
	attr_accessor :sign
	def initialize sign = true, tokens = []
	  @sign = sign
		@tokens = tokens
	end
	
	def to_s
	  "#{'not ' if !@sign}" + @tokens.join(' ')
	end
end