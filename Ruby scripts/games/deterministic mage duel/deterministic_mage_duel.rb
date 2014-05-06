require_relative '../helpers'

class DeterministicMageDuel
	class Creature
    attr_accessor :hp, :damage, :splash, :armor, :player
    
    def initialize player, damage, hp, armor = 0, splash = false
      @player, @damage, @hp, @armor, @splash = player, damage, hp, armor, splash
    end
    
    def hit damage
      hp -= [0, damage - armor].max
      
      player.creatures = player.creatures.select :alive?
    end
    
    def alive?
      hp > 0
    end
    
    def cost
      @damage + @armor + (@splash ? 2 : 0) + @hp/2
    end
    
    def move
      if @splash
        @player.opponent.creatures.each {|creature| creature.hit @damage}
        @player.oppenent.hit @damage
      else
        @player.tactic.target(self).hit @damage
      end
    end
    
    def to_s
      "#{@damage}/#{@hp}#{"a#{@armor}" if @armor > 0}#{'s' if @splash}"
    end
  end
  
  class Player
	  attr_accessor :mana, :hp, :creatures, :game, :tactic
		
		def initialize tactic, game
		  @tactic, @game = tactic, game
			@mana = 0
      @hp = 12
      @creatures = []
		end
    
    def opponent
      @game.players.find {|player| player != self}
    end
    
    def alive?
      @hp > 0
    end
    
    def hit damage
      @hp -= damage
    end
		
		def move
		  return if !alive?
      @creatures.each {|creature| creature.move}
      
      @mana += 2
      
      new_creatures = @tactic.create self
      @mana -= new_creatures.map(&:cost).inject(:+)
      @hp = 0 if @mana < 0
      
      @creatures += new_creatures
		end
		
		def to_s
		  "#{@creatures.join(' ')}#{' ' if @creatures.count > 0}#{@hp} (#{@mana})"
		end
	end
	
	MAX_TIME = 100

	class << self
    attr_accessor :last
  end
  
  attr_accessor :players, :result, :logger, :opened, :time

  def initialize *tactics
    @players = tactics.map { |t| Player.new t, self }
    self.class.last = self
		@result = nil
		@time = 0
  end
  
  def play
		players[1].mana += 1
    while players.select{|p| p.alive? }.size > 1
			players.each do |player|
        player.move
        log '', self
      end
			@time += 1
			players.each {|p| p.hp = 0} if @time > MAX_TIME 
		end
		@result = players.index players.find{|p| p.alive?}
  end
	
	def to_s
	  @players.map(&:to_s).join ' - '
	end

end 
