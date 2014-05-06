def print lab,x,y
  system 'cls'
  under = lab[x][y]
	lab[x][y] = 'O'
	puts lab.join("\n")
	lab[x][y] = under	
	sleep 0.001
end

lab = IO.read('lab.txt').split("\n")
x,y = nil,nil
lab.each_with_index do |line, i|
  line.chars.each_with_index do |char, j|
	  if char == 'S'
		  x,y = i,j
			break
		end
	end
	break if x
end

moves = [[1,0],[-1,0],[0,1],[0,-1]]
h,w = lab.size,lab[0].size
lab[x][y] = '.'

print lab,x,y	

while 1 
  move = moves[rand(moves.size)]
	x1,y1 = (x+move[0])%h,(y+move[1])%w
	x,y=x1,y1 unless lab[x1][y1] == '#'
	print lab,x,y	    
end

