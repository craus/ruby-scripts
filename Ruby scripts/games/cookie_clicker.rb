def compare a,b,c,d,x
  r = 1.0*a/x+1.0*c/(x+b) <=> 1.0*c/x+1.0*a/(x+d)
  xc = nil
  xc = (c-a)*b*d*1.0/(a*d-b*c) if a*d-b*c != 0
  xc = nil if xc && xc <= 0
  message = case
        when r < 0 then "Prefer #{a} (+#{b})"
        when r > 0 then "Prefer #{c} (+#{d})"
    else "Equal"  
        end
        r
end
 
def emulate bs, x
        time = 0
        speed = x
        bs.each do |b|
                time += 1.0*b[0]/speed
                speed += b[1]
                b[2],b[3] = time,speed
        end
        time
end
 
def order bs, x
        bs = bs.map{|b|b.dup}
        best = nil
        besttime = Float::INFINITY
        bs.permutation do |p|
          time = emulate p,x
          if time < besttime
                besttime = time
                best = p
          end
        end
        emulate(best,x)
        puts "+#{x}\n#{(0...best.size).to_a.map{|i| b=best[i];"#{i}) #{b[0]} (+#{b[1]}) at #{b[2]} (+#{b[3]} now)"}.join("\n")}" if $debug
        [best, besttime]
end
 
def order2 bs, x
        bs = bs.map{|b|b.dup}
        best = []
        speed = x
  bs.size.times do
        curbest = bs[0]
        (1...bs.size).each do |i|
                if compare(curbest[0], curbest[1], bs[i][0], bs[i][1], speed) > 0
                        curbest = bs[i]
                end
        end
        best << curbest
        speed += curbest[1]
        bs.slice!(bs.index(curbest))
  end
  emulate(best,x)
  puts "+#{x}\n#{(0...best.size).to_a.map{|i| b=best[i];"#{i}) #{b[0]} (+#{b[1]}) at #{b[2]} (+#{b[3]} now)"}.join("\n")}" if $debug
  [best,best[-1][2]]
end
 
def compare_orders bs, x
        o1 = order bs,x
        o2 = order2 bs,x
        (o1[1] - o2[1]).abs < 0.00000001
end
 
def random_bs n = 5, rnd = 0.1, base = 3, start = 10, profit = 0.3
        (0...n).to_a.map do |i|
                [start*base**i*(1+Random.rand*rnd), start*base**i*(1+Random.rand*rnd)*profit].map &:to_i
        end
end
 
def stress_orders ntests = 10, n = 5, rnd = 0.1, base = 3, start = 10, profit = 0.3, x = 1
  ntests.times do
        bs = random_bs(n,rnd,base,start,profit)
        #puts "stressing on #{bs}"
        if (!compare_orders(bs, x))
                return bs
        end
  end
  return nil
end
$debug = true
order [[3999999999, 999999], [30, 10], [100, 50]], 3














