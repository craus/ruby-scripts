a=(R=0..(M=8192)).map{(gets||'').split[0].to_i};a=a[1...n=a.index(0)];
p a.first
p a.last
p a.size
p R
p n
p M