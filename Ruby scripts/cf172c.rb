class Stud
	attr_reader :i,:t,:x
	attr_accessor :t_out
	def initialize i,t,x
		@i,@t,@x = i,t,x
		@t_out = nil
	end
	def <=> b
		x <=> b.x
	end
	def to_s
		"stud i=#{i}, t=#{t}, x=#{x}"
	end
end
n,m = gets.split.map &:to_i
st = []
0.upto(n-1) do |i|
	t,x = gets.split.map &:to_i
	st << Stud.new(i,t,x)
end
t = 0
ans = []
until st.empty?
	bus = []
	until bus.size == m or st.empty?
		stud = st.shift
		t = [t,stud.t].max
		bus << stud
	end
	bus.sort!
	x = 0
	until bus.empty?
		t += bus[0].x-x
		x = bus[0].x
		outed = 0
		until bus.empty? or bus[0].x > x
			outed += 1
			bus[0].t_out = t
			ans << bus[0]
			bus.shift
		end
		t += 1+outed/2
	end
	t += x
end
ans.sort_by! {|stud| stud.i}
puts ans.collect {|x| x.t_out}.join ' '


