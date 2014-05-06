require 'win32console'
require_relative '../tools'
require_relative 'rusher'
require_relative 'current'
require_relative 'slow_rusher'
require_relative 'matrix_mage_duel'

Dir["tactics/*.rb"].each do |file|
	require_relative file
end

play Current.new, SlowRusher.new, MatrixMageDuel