require_relative '../../tactic'

class Current < Tactic
	class << self
	  attr_accessor :last
	end
	
	def initialize
	  self.class.last = self
	end

	def ready_for_superstrike me, enemy
		case
			#last hit superstrike if not lethal for self
			when enemy.life + enemy.blocks <= 3 && me.life + me.blocks >= 2 then true
			#kamikaze superstrike
			when enemy.life + enemy.blocks == 3 then true
			#strategic superstrike if not harmful for self
			when me.life >= 2 && me.blocks >= 1 then true
			#strategic superstrike if not harmful for self
			when me.life >= 4 then true
			else false
		end
	end
	
	def ready_for_cure me, enemy
	  case
			#cure when cannot last hit
			when me.poison >= 3 && enemy.life + enemy.blocks >= 4 then true
			#strategic cure
			when me.poison >= 2 && enemy.life + enemy.blocks >= 7 && me.blocks + me.life >= 5 then true
			else false
		end
	end

	def action game
		me = game.mover
		enemy = me.enemy
		result = case 
			#cure when ready
			when me.moves >= 5 && ready_for_cure(me,enemy) then :cure
			#haste for cure when ready
			when me.moves == 4 && me.mana >= 2 && ready_for_cure(me, enemy) then :haste
			
			#superstrike when ready
			when me.moves >= 5 && me.mana >= 1 && ready_for_superstrike(me, enemy) then :superstrike
			#haste for superstrike when ready
			when me.moves == 4 && me.mana >= 2 && ready_for_superstrike(me, enemy) then :haste

			#haste for shoot-and-block when ready
			when me.moves == 4 && me.mana >= 2 && me.blocks == 0 then :haste
			
			#regen mana for superstrike
			when me.moves == 4 && me.blocks == 0 then :block # and then regen mana for superstrike
			#regen 2 mana 
			when me.moves == 4 then :regen_mana
			
			#strategic poison strike
			when me.moves >= 3 && enemy.blocks + enemy.life >= 7 && me.blocks + me.life >= 5 && enemy.poison <= 1 then :poison_strike
			#prefer block yourself than just shoot enemy's block
			when me.moves >= 2 && me.blocks == 0 && enemy.blocks == 1 then :block 
			#fire
			when me.moves >= 3 then :fire
			
			#haste for fire when no block needed
			when me.moves == 2 && me.blocks == 1 && me.mana >= 2 then :haste
			
			#block
			when me.moves >= 2 && me.blocks == 0 then :block
			#regen mana
			when me.moves >= 2 then :regen_mana
			#boo
			when me.moves >= 1 && me.first_action then :boo
			
			else :end_turn
		end
		result
	end
end