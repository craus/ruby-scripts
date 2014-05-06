require_relative 'lang'

MAX_LEN = 11
@res = {}
@errors = 0

def dfs s, deep
  puts "here: #{s}" if s == '`ks' 
  if deep == 0
		res = run_function s
	  if res.nil?
		  #puts("error: #{s}") 
			@errors += 1
			return
		end
		key = key_string(res) 
		@res[key] = [s, res[3]] if @res[key].nil? || @res[key][1] > res[3]
		return
	end
	dfs s+'k', deep-1
  dfs s+'s', deep-1
	dfs s+'`', deep+1 if MAX_LEN-s.size-deep >= 2
end

def key_string key
  "#{key[0].join} : #{key[2].size > 0 ? key[2].join('; ') : '-'}\n  #{key[1]}"
end

dfs '', 1

@messages = []

@res.each do |key, value| 
  message = "#{value[0]}\n#{key}\napplies: #{value[1]}"
	@messages.push message
end

puts "Errors: #{@errors}"
puts

puts @messages.sort_by {|x| x.size}.join("\n\n")