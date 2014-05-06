def fall x
  return 0 if x == 0
  x % 2 == 0 ? fall(x/2) : x
end

def left x
  fall 3*x-1
end

def right x
  fall 3*x+1
end  

def children x, level = 1
  return [x] if level == 0
  return (children(left(x), level-1) + children(right(x), level-1)).uniq
end

def picker x
  return (x-1) if x%3==1
  return (x+1) if x%3==2
  nil
end

def parents x, cnt = 1 
  return nil if x%3 == 0
  res = []
  while res.size < cnt
    x *= 2
    p = picker x
    res << p/3 if p%9 != 0
  end
  res
end

def parent x
  return parents(x)[0] 
end

def grandparent x
  p = parent x
  p >= x ? x : grandparent(p)
end

def king x, level = 1
  return grandparent(x) == x if level == 1
  grandparent(x) == x && king(parent, level-1)
end

def kingness x
  res = 0
  while king x
    res += 1
    x = parent x
  end
  res
end

def up x 
  [left(x), right(x)].max
end 

def down x
  [left(x), right(x)].min
end

def level x
  p = parent x
  p >= x ? 1 : 1+level(p)
end

def desc x
  "#{x} (#{grandparent(x)}:#{level(x)})"
end  

def line x, cnt = 1
  cnt == 0 ? [] : [x] + line(up(x), cnt-1)
end

def shortest_path x, y
  map = {x => 0}
  from = {x => nil}
  queue = [x]
  while !map.key?(y)
    z = queue.shift
    if !map.key?(down(z))
      map[down(z)] = map[z]+1
      queue << down(z)
      from[down(z)] = z
    end
    if !map.key?(up(z))
      map[up(z)] = map[z]+1
      queue << up(z)
      from[up(z)] = z
    end
  end
  res = [y]
  res << from[res[-1]] while res[-1] != x
  res.reverse
end

def dist x, y
  shortest_path(x,y).size-1
end

def valid x
  x%2 != 0 && x%3 != 0
end

def till x, y
  x.upto(y).select{|x|valid x}
end

def pathdown x
  res = [x]
  while x != 5
    x = (down(x)==1 ? up(x) : down(x))
    res << x
  end
  res
end

def pathup x
  res = [x]
  while x != 5
    x = parent(x)
    res << x
  end
  res.reverse
end

def path x,y
  (pathdown x)[0...-1] + (pathup y)
end

def path_length x,y
  path(x,y).size-1
end

def path_desc x,y
  path(x,y).map{|x| desc(x)}.join("\n")
end

def action x,y
  return '-' if left(x) == y
  return '+' if right(x) == y
  return path_actions x,y
end

def path_actions x,y
  p = path(x,y)
  (0..p.size-2).each.map{|i| action(p[i],p[i+1])}.join
end

def by_place line, index
  index == 1 ? line : by_place(up(line),index-1)
end

def show x, with = :none
  return "#{x}[#{p[x]}]" if with == :parent
  return "#{x}(#{children(x).join(', ')})" if with == :childs
  return "#{x}" if with == :none
end

def hierarchy x,level,with = :none
  h = {x => 0, 1 => -1}
  p = {}
  a = [[x]]
  1.upto(level) do |deep|
    b = a[-1]
    c = []
    b.each do |z|
      children(z).each do |y|
        unless h.key?(y)
          h[y] = deep
          p[y] = z
          c << y
        end
      end
    end
    a << c
  end
  a.map{|b| b.map{|x| show(x,with)}.join(' ')}.join("\n")
end

def way_down x
  return [x] if x == 1
  return [x] + way_down(down(x))
end

def way_up_to x
  return [x] if parent(x) >= x
  return way_up_to(parent(x)) + [x]
end

def console
  loop do
    c, *a = gets.split
    a = a.map(&:to_i)
    if c.to_i.to_s == c 
      a.unshift c.to_i
      c = 'desc'
    end
    
    case c
      when 'exit' then exit
      when 'desc' then puts desc(a[0])
      when 'from' then puts hierarchy(a[0],a[1]||3)
      when 'to' then puts parents(a[0],a[1]||5).join(' ')
      when 'way' then puts shortest_path(a[0]||5,a[1]||5).join(' ')
      when 'dway' then puts shortest_path(a[0]||5,a[1]||5).map{|x|desc(x)}.join(' ')
      when 'tree' then puts hierarchy(a[0],a[1]||3)
    end
  end
end

till(5,200).each{|x| puts way_up_to(x).join(' ')}

till(5,200).each{|x| puts way_down(x).join(' ')}


