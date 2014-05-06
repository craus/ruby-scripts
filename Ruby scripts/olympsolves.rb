M = 300
ar = [0]*(M+1)
primes = []
primes2 = []
primes3 = []
sum = 0
2.upto(M) do |x|
	if ar[x] == 0 
		primes << x
		primes2 << x**2
		primes3 << x**3
		y = x
		while x <= M
			ar[x] = 1
			x += y
			sum += 1
		end
	end
end

puts primes.size
sqrs = Hash.new(0)

1.upto(4000) {|i| sqrs[i*i] = 1}

a,n = gets.split.map &:to_i
sum = 0
ops = 0
a.upto(a+n-1) do |x|
	p x,ops if x % 100000 == 0
	res = 1
	0.upto(primes.size-1) do |i|
		break if primes3[i] > x
		ops += 1
		prime = primes[i]
		prime2 = primes2[i]
		#while x % prime2 == 0
		#	x /= prime2
		#	ops += 1
		#end
		if x % prime == 0
			res *= prime 
			x /= prime
		end
	end
	res *= x if sqrs[x] == 0
	sum += res
end
p sum