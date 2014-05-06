def left x
  $g[x][0]
end

def right x
  $g[x][1]
end  

def exist x
  $g.key? x
end

def children x, level = 1
  return [x] if level == 0
  return (children(left(x), level-1) + children(right(x), level-1)).uniq
end

def parents x, cnt = 1 
  res = []
  i = 1
  while cnt > 0 
    return res unless exist(i)
    if $g[i].include?(x)
      res << i
      cnt -= 1
    end
    i += 1
  end
  res
end

def parent x
  return parents(x)[0] 
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

def shortest_path x, y
  map = {x => 0}
  from = {x => nil}
  queue = [x]
  while !map.key?(y) && queue.size > 0
    z = queue.shift
    next unless exist(z)
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
  return [] if !map.key?(y)
  res = [y]
  res << from[res[-1]] while res[-1] != x
  res.reverse
end

def dist x, y
  shortest_path(x,y).size-1
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


