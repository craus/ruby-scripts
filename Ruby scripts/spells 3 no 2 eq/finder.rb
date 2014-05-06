$max_depth = 14
$finished = 0
$unfinished = 0
$max_length = 0

def check s
  2.upto(s.size) do |len|
    x = (len+1)/2
    x -= len/8
    return s[-x..-1] if s[-len..-len+x-1] == s[-x..-1]
  end
  return nil
end

def dfs s
  $max_length = [$max_length, s.size].max
  if check s
    #puts "#{s} - #{check s}"
    $finished += 1
    return
  end
  if s.size == $max_depth
    #puts "#{s}..."
    $unfinished += 1
    return
  end
  dfs s + 'a'
  dfs s + 'b'
  dfs s + 'c'
end

dfs ''

puts "Finished: #{$finished}"
puts "Unfinished: #{$unfinished}"
puts "Max length: #{$max_length}"





  