def inf 
	1e9
end

def attack_cost a
  a*a/4
end

def damage attack, armor
  [0, attack-armor].max
end

def ucost attack, armor
  return inf if damage(attack, armor) == 0
	attack_cost(attack) / damage(attack, armor)
end

def armor a
  costs = (0..1000).to_a.map{|x|ucost(x,a)}
	cost = costs.min
	best_attack = costs.index cost
	[cost, best_attack]
end

(1..100).each do |x| 
  a = armor x
	puts "Armor #{x} costs #{a[0]}, optimal attack #{a[1]}"
end