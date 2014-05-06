require_relative '../tactic'

Poisoner = Tactic.new do |game|
  me = game.mover
	enemy = me.enemy
	case 
	  when me.moves >= 5 && me.mana >= 1 && (me.life + me.blocks > 1 || enemy.life + enemy.blocks <= 3) then :superstrike
		when me.moves >= 3 && enemy.blocks + enemy.life >= 7 && me.blocks + me.life >= 5 && enemy.poison <= 5 then :poison_strike
		when me.moves >= 3 then :fire
		when me.moves >= 2 && me.blocks == 0 then :block
		when me.moves >= 2 && me.mana == 0 then :regen_mana
		when me.moves >= 1 then :boo
		else :end_turn
	end
end

# ����� ����� ��� �� �������, ���� �� ���������� ������ 