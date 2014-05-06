D = 6
G = 10
W = 16
LCM = 240.0

class Fixnum
	%w(d g w).each do |resource|
		define_method resource.to_sym do
			self == 0 ? 0 : (self-1).send(resource.to_sym) + LCM / (Kernel.const_get(resource.upcase.to_sym))
		end
	end
end

class UnitType
	def initialize cost, power
		@power, @cost = power, cost
	end

	def to_s
		"#{@power} * #{@cost/@power} = #{@cost}"
	end
end

def first_scale
	puts UnitType.new(1.w, 1) #1
	puts UnitType.new(2.w, 3) #2
	puts UnitType.new(2.g+3.w, 10) #7
	puts UnitType.new(1.d+3.g+4.w, 20) #13
	puts UnitType.new(2.d+3.g+6.w, 30) #18
	puts UnitType.new(3.d+6.g+8.w, 60) #29
	puts UnitType.new(4.d+7.g+10.w, 100) #36
	puts UnitType.new(5.d+8.g+13.w, 200) #44
	puts UnitType.new(6.d+10.g+16.w, 1000) #54
end

def u cost, power
	puts UnitType.new(cost, power)
end

def second_scale
	u 1.w, 1 #1
	u 2.w, 3 #2
	u 1.g+2.w, 5 #4
	u 2.g+3.w, 10 #7
	u 1.d+2.g+3.w, 15 #10
	u 2.d+3.g+5.w, 30 #17
	u 3.d+5.g+8.w, 60 #27
end

def const_scale
  u 1.w, 1
	u 2.w, 3
	u 1.g+2.w, 5
	u 2.g+3.w, 10
	u 1.d+2.g+3.w, 15
	u 2.d+3.g+4.w, 25
	u 3.d+4.g+5.w, 50
	u 4.d+5.g+6.w, 100
end

const_scale