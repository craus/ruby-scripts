$stats = [0,0,0,0,0,0]
$gold = 50

def dice
  rand(6)+1
end

def gdice
  x = dice
  x >= 5 ? 4+gdice : x 
end

def player_power
  $stats.inject(:+)
end

def print_stats
  puts "Your stats: #{$stats.join ', '}"
end

def print_gold 
  puts "Your gold: #{$gold}"
end

def print_all
	print_gold
	print_stats
end

def move
	print_all
	puts "Select difficulty level, integer not less than 0."
  difficulty = gets.to_i
  if difficulty == 0 
    $gold += 1
		puts "You earned 1 gold"
  else
    puts "Your power: #{player_power}"
    monster = gdice * difficulty
    puts "Monster of level #{monster} against you"
    if monster > player_power
      puts "You lose"
      damage = dice
      puts "Your stat ##{damage} brokes by 2"
      $stats[damage-1] /= 2
      print_stats
    else
      puts "You win"
      puts "You gain #{monster} gold"
      $gold += monster
    end
  end
  trade = dice
  power = gdice
  cost = 5*power
  print_all
	puts "Trade offer: stat #{trade} up to #{power} costs #{cost} golds"    
  if $gold < cost
    puts "You cannot afford it"
  else
    puts "'y' to buy it, any string not to buy"
    if gets[0] == 'y'
      $stats[trade-1] = power
      $gold -= cost
    end
  end
end


loop do move end