require_relative 'lang'
if ARGV[0].nil?
  puts "Need argument for program file name"
  exit
end
$debug = ARGV.include? 'd'
$result = ARGV.include? 'r'
$binary = ARGV.include? 'b'
$binary_input = ARGV.include?('bi') || $binary
$binary_output = ARGV.include?('bo') || $binary

run_program ARGV[0]
