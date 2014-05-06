require_relative 'deterministic_mage_duel'

class Current 

  def dynamic situation
    
  end

	def target creature
		creature.player.opponent
	end
  
  def create player
    [
      DeterministicMageDuel::Creature.new(player, player.mana, 1)
    ]
  end
end