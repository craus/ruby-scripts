s = IO.read 'output.txt'
a = s.split.map(&:to_i)
a.each {|x| p "error #{x} #{x.class}" unless [Fixnum, Bignum].include? x.class}
p a.size
