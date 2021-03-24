class Regex1


	def initialize
		super
	end

	def self.evenBrackets(expression)
		openBrackets = expression.count("(")
		closeBrackets = expression.count(")")
		return openBrackets == closeBrackets
	end

	def self.correctastrix(expression)
		if expression[0] == "*"
			return false
		end
		(1..expression.size-1).each { |i|
			if expression[i] == "*"
				if expression[i-1] == "|" || expression[i-1] == "("
					return false
				end
			end
		}
		return true
	end

	if ARGV.length < 2
		puts "Too few arguments"
		exit
	elsif ARGV.length > 2
		puts "Too many arguments"
		exit
	elsif ARGV.length == 2
		expressions = ARGV[0]
		targets = ARGV[1]
		output = File.open("output.txt","w")
		exFile = File.open(expressions)
		exLines = File.read(exFile).split("\n")
		tarFile = File.open(targets)
		tarLines = File.read(targets).split("\n")
		puts exLines.size
		(0..exLines.size-1).each { |i|
			expression = exLines[i];
			target = tarLines[i];
			# puts expression
			# puts target
			match = false
			if target == expression
				puts "YES: " + expression +  " with " + target + "\n"
				output.write("YES: " + expression +  " with " + target + "\n")
			elsif !evenBrackets(expression)
				puts "SYNTAX ERROR: " + expression +  " with " + target + "\n"
				output.write("SYNTAX ERROR: " + expression +  " with " + target + "\n")
			elsif !correctastrix(expression)
				puts "SYNTAX ERROR: " + expression +  " with " + target + "\n"
				output.write("SYNTAX ERROR: " + expression +  " with " + target + "\n")
			elsif target.match(/^(expression)$/)
				puts "YES: " + expression +  " with " + target + "\n"
				output.write("YES: " + expression +  " with " + target + "\n")
			else
				#l = Lex.new(expression)
				#puts l.get_token()
				puts "NO: " + expression +  " with " + target + "\n"
				output.write("NO: " + expression +  " with " + target + "\n")
			end
		}
		exFile.close
		tarFile.close
	end
end

class Token
	$name = ""
	$value = ""

	def initialize(n,v)
		$name = n
		$value = v
	end

end

class Testing
	$pattern = ""
	$symbols = Hash.new()
	$current = 0
	$length = 0;

	def initialize(p)
		$pattern = p;
		$symbols = { "(" => "LEFT_PAREN" , ")" => "RIGHT_PAREN", "*" => "AST", "|" => "OR", "." => "DOT"}
		$current = 0;
		$length = p.length
	end

	def get_token
		if $current < $length
			cur = $pattern[$current]
			$current = $current + 1

			if !$symbols.has_key?(cur)
				return new Token("CHAR",cur)
			else
				return new Token([cur],cur)
			end
		else
			return Token("NONE","")
		end
	end
end

