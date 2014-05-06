require_relative '../tactic'

class WarriorBackup < Tactic
	def action game
		me = game.mover
		enemy = me.enemy
		case 
			#cure when cannot last hit
			when me.moves >= 5 && me.poison >= 3 && enemy.life + enemy.blocks >= 4 then :cure
			#strategic cure
			when me.moves >= 5 && me.poison >= 2 && enemy.life + enemy.blocks >= 7 && me.blocks + me.life >= 5 then :cure
			
			#last hit superstrike if not lethal for self
			when me.moves >= 5 && me.mana >= 1 && enemy.life + enemy.blocks <= 3 && me.life + me.blocks >= 2 then :superstrike
			#kamikaze superstrike
			when me.moves >= 5 && me.mana >= 1 && enemy.life + enemy.blocks == 3 then :superstrike
			#strategic superstrike if not harmful for self
			when me.moves >= 5 && me.mana >= 1 && me.life >= 2 && me.blocks >= 1 then :superstrike
			
			#regen mana for superstrike
			when me.moves == 4 && me.mana == 0 && me.blocks == 0 then :block # and then regen mana for superstrike
			
			#strategic poison strike
			when me.moves >= 3 && enemy.blocks + enemy.life >= 7 && me.blocks + me.life >= 5 then :poison_strike
			#prefer block yourself than just shoot enemy's block
			when me.moves >= 2 && me.blocks == 0 && enemy.blocks == 1 then :block 
			#fire
			when me.moves >= 3 then :fire
			
			#block
			when me.moves >= 2 && me.blocks == 0 then :block
			#regen mana for superstrike
			when me.moves >= 2 && me.mana == 0 then :regen_mana
			#boo
			when me.moves >= 1 then :boo
			
			else :end_turn
		end
	end
end