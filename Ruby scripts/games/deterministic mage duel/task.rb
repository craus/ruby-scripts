require 'win32console'
require_relative '../tools'
require_relative 'current'
require_relative 'deterministic_mage_duel'

Dir["tactics/*.rb"].each do |file|
	require_relative file
end

play Current.new, Current.new, DeterministicMageDuel