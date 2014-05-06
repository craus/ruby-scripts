require_relative 'lang'
if ARGV[0].nil?
  puts "Need argument for program file name"
  exit
end
$debug = ARGV.include? '-d'
$result = ARGV.include? '-r'

run_program ARGV[0]
