def read_frequences filename
  h = {}
  IO.read(filename).split("\n").each do |s|
	ss = s.split('-').map &:strip
	h[ss[0][1]] = ss[1].to_i
  end
  h
end

L = 7

def norm a
  sum = a.inject :+
  a.each_index {|i| a[i] = [a[i]*L/sum,1].max if a[i] != 0 }
  puts "a = #{a}"
  add = L-a.inject(:+)
  a.each_index {|i| a[i] += 1 if add > 0 && a[i] != 0; add -= 1}
end

def encode f1,f2,input
  a1 = f1.keys
  a2 = f2.keys
  f1 = norm f1.values
  f2 = norm f2.values
  f1t = f1
  f2t = f2
  output = ''
  input.each_char do |c|
    i = a1.index c
	puts "i = #{i}, f1t = #{f1t}, f2t = #{f2t}"
	left1 = f1t.first(i).inject(:+) || 0
	right1 = left1 + f1t[i]
	left2 = 0
	f2t.each_index do |i|
	  old = f2t[i];
	  right2 = left2 + old
	  left_new = [left1,left2].max
	  right_new = [right1,right2].min
	  length_new = right_new-left_new
	  f2t[i] = length_new
	  left2 += old;
	end
	puts "f2t on: #{f2t}"
	f2t = norm f2t
	
  end
  output
end

a1f,a2f,input,output = ARGV
a1f = read_frequences a1f
a2f = read_frequences a2f
res = encode(a1f,a2f,IO.read(input))
puts norm [3,2,9,2,0,0,0,7,2]
#File.open(output, 'w') { |f| f.write res }