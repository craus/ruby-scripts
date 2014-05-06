class Player
	ACTIONS = %w(end_turn fire block superstrike regen_mana mana_block haste boo poison_strike cure mana_break).map &:to_sym
	ACTION_COLORS = {
	  fire: [:red, :bold], 
		block: :bold,
		superstrike: [:red, :bold],
		regen_mana: :cyan,
		poison_strike: [:green, :bold],
		cure: [:cyan, :bold],
	}
	WRONG_TURN = Exception.new('Wrong turn')
	
	%w(life mana blocks moves tactic poison game booed first_action).map(&:to_sym).each {|attr| attr_accessor attr}

	def enemy
	  game.players.find{|p| p != self}
	end
	
	def end_turn
		@moves = 0
	  enemy.start_move
	end
	
	def fire
	  @moves -= 3
		raise WRONG_TURN if @moves < 0
	  enemy.hit
	end
	
	def block
		@moves -= 2
		raise WRONG_TURN if @moves < 0 || @blocks > 0
		@blocks += 1 
	end
	
	def superstrike
		@moves -= 5
		raise WRONG_TURN if @moves < 0 || @mana < 1
	  hit
		3.times {enemy.hit}
	end
	
	def regen_mana
		@cost = @blocks >= 2 ? 1 : 2
	  @moves -= @cost
		raise WRONG_TURN if @moves < 0 
		@mana += 1
	end
	
	def mana_block
	  @mana -= 4
		raise WRONG_TURN if @mana < 0 || @blocks > 1
		@blocks += 1		
	end
	
	def haste
	  @mana -= 1
		raise WRONG_TURN if @mana < 0
		@moves += 1
	end
	
	def boo
	  @moves -= 1
		raise WRONG_TURN if @moves < 0 || !@first_action
		enemy.booed = 1
		end_turn
	end
	
	def poison_strike
	  @moves -= 3
		raise WRONG_TURN if @moves < 0
		enemy.poison += 1
	end
	
	def cure
		@moves -= 5
		raise WRONG_TURN if @moves < 0
		@poison = 0
	end
	
	def mana_break
	  @moves -= 5
		raise WRONG_TURN if @moves < 0
		enemy.mana = 0
	end
	
	def hit mode = :normal
	  if @blocks > 0 && mode != :unblockable
		  @blocks -= 1
		else
		  @life -= 1
		end
	end
	
  def initialize tactic, game
		@tactic, @game = tactic, game
	  @life = 7
		@mana = @blocks = @moves = @poison = @booed = 0
  end
	
	def alive?
	  @life > 0
	end
	
	def index
	  @game.players.index self
	end
	
	def name
		"#{index == 0 ? 'First' : 'Second'} player"
	end
	
	def start_move
	  @game.mover = self
	  @moves = Random.dice
		hit :unblockable if moves <= poison
		@moves -= booed
		@booed = 0
		@first_action = true
	end
	
	def colored action
	  colors = ACTION_COLORS[action] || []
		colors = [colors] if colors.class != Array
		s = action.to_s
		colors.each do |c|
		  s = s.send c
		end
		s
	end
	
	def act 
	  action = tactic.action @game
		action = :end_move if !ACTIONS.include? action
		
		begin
			send(action) 
		rescue Exception => e  
			end_turn
			action = :end_turn
		end
		
		log colored action
		@first_action = false
	end
	
	def to_s
	  "#{"#{@life}".red.bold}/#{"#{@mana}".cyan}/#{"#{@blocks}".bold}/#{"#{@poison}".green.bold}/#{@moves}#{-"#{@booed}" if @booed > 0}"
	end
end