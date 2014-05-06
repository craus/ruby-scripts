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

n,m=ARGV.map &:to_i
puts "#{n} #{m}"
st = []
n.times { st << Stud.new(0,rand(100000), rand(100000)) }
st.sort_by! {|stud| stud.t}
puts st.collect {|stud| "#{stud.t} #{stud.x}"}.join "\n"