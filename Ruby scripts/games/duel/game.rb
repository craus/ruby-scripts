require_relative 'player'
require_relative '../helpers'

class Game
  class << self
    attr_accessor :last
  end
  
  attr_accessor :players, :result, :mover, :logger

	def dup
	  copy = super
		mover_index = players.index mover
		copy.players = players.map{|p| r = p.dup; r.game = copy; r}
		copy.mover = copy.players[mover_index]
		copy
	end
	
  def initialize *tactics
    @players = tactics.map { |t| Player.new t, self }
    self.class.last = self
		@result = nil
  end
  
  def play
    players.random.start_move
		while players.select{|p| p.alive? }.size > 1
			log '', self
			mover.act 
		end
		@result = players.index players.find{|p| p.alive?}
  end
	
	def to_s
	  "[#{@players.index @mover}] #{@players.map(&:to_s).join ' '}"
	end
end 