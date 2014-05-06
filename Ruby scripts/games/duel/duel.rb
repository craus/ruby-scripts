require 'win32console'
require_relative '../tools'
require_relative 'game'

Dir["tactics/*.rb"].each do |file|
	require_relative file
end

compare Current.new, Haster.new, Game
























