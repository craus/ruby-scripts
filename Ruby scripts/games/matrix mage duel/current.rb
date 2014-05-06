class Current 
	class << self
	  attr_accessor :last
	end
	
	def initialize 
	  self.class.last = self
	end

	def action game, me
		res = case
      when game.time == 0 then :p
			when me.mana >= me.power * (me.power+300) then :o
			when me.mana == 0 && Random.rand < 0.5 then :p
			else :m
		end
		res
	end
end