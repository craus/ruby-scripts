class Function
  def initialize name, args_names = [], tokens = []
    @name = name
    @args_names = args_names
    @tokens = tokens
  end
  
  def apply x
    puts "Applying #{self} to #{x}" if $debug
    return @tokens + [x] if @args_names.size == 0
    Function.new(@name+" "+x.to_s, arg=@args_names[1..-1], @tokens.map{|token| token == @args_names[0] ? x : token})
  end
  
  def check
    @args_names.size == 0 ? @tokens : nil
  end
  
  def add tokens
    #@tokens << '(' if tokens.size > 1
    tokens.each{|x| @tokens << x}
    #@tokens << ')' if tokens.size > 1
  end

  
  def full_desc
    "#{@name} #{@args_names.join(' ')} = #{@tokens.join(' ')}"
  end
  
  def to_s
    "[#{@name}]"
  end
end