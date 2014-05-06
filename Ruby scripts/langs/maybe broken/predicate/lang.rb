require_relative 'parser'

def run 
	puts $data.join("\n")
	puts $consts.join(" ")
	puts $vars.join(" ")
end

def run_program file
  readfile file
  run
end