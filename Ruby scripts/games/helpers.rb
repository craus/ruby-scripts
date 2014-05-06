class BasicObject
  def log *args
	  args.each {|x| puts x} if !$silent
	end
end

class String
  { :reset          =>  0,
    :bold           =>  1,
    :dark           =>  2,
    :underline      =>  4,
    :blink          =>  5,
    :negative       =>  7,
    :black          => 30,
    :red            => 31,
    :green          => 32,
    :yellow         => 33,
    :blue           => 34,
    :magenta        => 35,
    :cyan           => 36,
    :white          => 37,
  }.each do |key, value|
    define_method key do
      "\e[#{value}m#{self}\e[0m"
    end
  end
	
	{ :black          => 40,
    :red            => 41,
    :green          => 42,
    :yellow         => 43,
    :blue           => 44,
    :magenta        => 45,
    :cyan           => 46,
    :white          => 47,
  }.each do |key, value|
    define_method :"#{key}_back" do
      "\e[#{value}m#{self}\e[0m"
    end
  end
end

class Random
  def self.dice
	  1 + rand(6)
	end
end

class Array
  def random
    self[Random.rand self.size]
  end
end

class Numeric
  def with_sign
	  "#{'+' if self > 0}#{self}"
	end
end