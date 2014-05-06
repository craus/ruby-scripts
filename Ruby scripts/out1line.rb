puts IO.read(ARGV[0])
File.open('output.txt', 'w') {|f| f.write('doc') }
