require_relative '../helpers'

class MatrixMageDuel
	class Player
	  attr_accessor :mana, :power, :game, :tactic, :alive
		
		def initialize tactic, game
		  @tactic, @game = tactic, game
			@alive = true
			@mana = @power = 0
		end
		
		def move
		  action = @tactic.action @game, self
			case action
			  when :p then @power += 1
				when :m then @mana += @power
				when :o then @mana -= 0.5; @game.opened = true
			end
		end
		
		def to_s
		  "(#{power}, #{mana}#{', X' if !alive})"
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
		@opened = false
		@time = 0
  end
  
  def play
		while players.select{|p| p.alive }.size > 1
			log '', self
			players.each &:move
			if @opened 
				log 'Opening:', self
			  value = players.max_by(&:mana).mana
				players.each {|p| p.alive = false if p.mana < value }
				@opened = false
			end
			@time += 1
			players.each {|p| p.alive = false} if @time > MAX_TIME 
		end
		@result = players.index players.find{|p| p.alive}
  end
	
	def to_s
	  @players.map(&:to_s).join ' '
	end

end 
