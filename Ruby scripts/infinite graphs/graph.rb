require_relative 'lab'

def rnd x, excepts = []
  begin
    r = rand(1..3*x) 
  end while excepts.include?(r) || r==x
  r
end

def rand_graph n, k
  edges = {}
  1.upto(n) do |x|
    k.times {(edges[x] ||= []) << rnd(x,edges[x])}
  end
  edges
end

$g = rand_graph 10000, 2

$g.first(100) do |x,to|
  puts "#{x} to #{to.join(', ')}"
end

1.upto(100) do |i|
  puts shortest_path(1,i).join(' ')
end