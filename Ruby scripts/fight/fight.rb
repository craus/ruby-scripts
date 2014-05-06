class Creature
  attr_accessor :strength, :health, :dexterity, :luck, :armor, :current_health
	
	def initialize strength = 1, health = 1, dexterity = 1, luck = 1, armor = 1
	  @strength, @health, @dexterity, @luck, @armor = strength, health, dexterity, luck, armor
	end
	
	def born
	  @current_health = @health
		self
	end
	
	def alive?
	  @current_health > 0
	end
	
	def attack_power
	  2 * Math.sqrt(@strength)
	end
	
	def hit target
	  damage = 0
		0.upto(@luck) { damage += rand*attack_power }
		damage /= (@luck + target.luck)
		puts "damage is #{damage}"
		damage = damage.to_i
		damage -= target.armor
		damage = 0 if damage < 0
		target.health -= damage
	end
end

def print_health p1, p2
  puts "#{p1.current_health} - #{p2.current_health}"
end

def fight p1, p2
  print_health p1, p2
	while p1.alive? && p2.alive? 
	  mover, victim = p2,p1
		mover,victim = p1,p2 if rand(p1.dexterity+p2.dexterity) < p1.dexterity
		mover.hit(victim)
		print_health p1,p2
	end
end

p1 = Creature.new(*ARGV.shift(5).map(&:to_i)).born
p2 = Creature.new(*ARGV.shift(5).map(&:to_i)).born

fight p1, p2




