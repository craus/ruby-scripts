class Creature
  attr_accessor :damage, :hp, :max_hp, :mana, :max_mana, :abilities, :name
	def initialize name,damage,max_hp,max_mana=0,abilities={}
	  @name,@damage,@max_hp,@max_mana,@abilities = name,damage,max_hp,max_mana,abilities
		@hp,@mana = @max_hp,@max_mana
	end
	
	def to_s
	  return "dead" if dead?
		"d #{@damage}  hp #{@hp}/#{@max_hp}#{"  m #{@mana}/#{@max_mana}" if @max_mana > 0}"
	end
	
	def hit fight, damage, dealer
	  damage = [damage,@hp].min
		was_dead = dead?
		@hp -= damage
		puts "#{dealer.name} deals #{damage} damage to #{name}#{" (#{@hp}/#{@max_hp})" if alive?}"
		if dead?
		  puts "#{name} is #{"still " if was_dead}dead"
		  fight.bury self 
		end
	end
	
	def attack fight, creature
	  creature.hit fight, @damage, self
	end
	
	def heal creature
	  return "You have no heal ability" unless @abilities.key? :heal
		return "Not enough mana (#{@mana} instead of 1)" if @mana < 1
    @mana -= 1
		creature.restore_hp 3, self unless creature.dead?
		nil
	end
	
	def restore_hp x, healer
	  x = [@max_hp-@hp,x].min
		@hp += x
		puts "#{healer.name} heals #{x} hp to #{name}#{" (#{@hp}/#{@max_hp})" if alive?}"		
	end
	
	def alive?
	  @hp > 0
	end
	
	def dead?
	  !alive?
	end
end

class Monster < Creature
  def turn fight
	  attack fight, fight.player
	end
	
	def initialize *args
	  args.unshift 'Monster' unless args[0].class == String
		super
	end
end

class Player < Creature
  def turn fight
	  puts "you: #{self}"
		puts "monsters:\n#{(0...fight.monsters.size).map{|i|"(#{i+1})   #{fight.monsters[i]}"}.join("\n")}"
		loop do
			c = gets.chomp
			status = case
				when c.to_i.to_s == c then attack fight, fight.monsters[c.to_i-1]
				when c == 'h' then try(heal self)
				else 
				  puts "Unknown command"
					:retry
			end
			return status unless status == :retry
		end
	end	
	
	def try action_result
	  if action_result.class == String
		  puts action_result
			return :retry
		end
		action_result
	end
	
	def initialize *args
	  args.unshift 'Player' unless args[0].class == String
		super
	end
end

class Fight
  attr_accessor :player, :monsters
	
	def initialize player, monsters
	  @player, @monsters = player, monsters
	end

  def turn
		x = @player.turn self
		return x if x
		@monsters.select(&:"alive?").each{|m| return x if (x = m.turn self)}
		nil
	end
	
	def run 
	  x = turn until x
		x
	end
	
	def bury creature
	  return :lose if @player.dead?
		:win if @monsters.select(&:"alive?").empty?		
	end
	
end  

puts "You #{Fight.new(Player.new(1,4,3,{heal: 1}), (1..2).map{|i|Monster.new("Monster ##{i}",1,1+i)}).run}"


