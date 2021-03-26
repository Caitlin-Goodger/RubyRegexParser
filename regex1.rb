class Regex1


	def initialize
		super
	end


	def self.evenBrackets(expression)
		openBrackets = expression.count("(")
		closeBrackets = expression.count(")")
		return openBrackets == closeBrackets
	end

	def self.correctasterick(expression)
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

	def match(expression,target)
		if(target.nil? || target.empty?) && (expression.nil? || expression.empty?)
			return true
		elsif expression[1] == "*"
			return astrickMatch(expression,target)
		elsif expression[0] == "("
			return bracketMatch(expression,target)
		elsif expression.include?("|")
			return orMatch(expression,target)
		else
			return compareFirst(expression[0],target[0]) && match(expression.drop(1),target.drop(1))
			#compareFirst(expression[0],target[0]) && match(expression[1...expression.size()],target[1...target.size()])
		end
	end

	def astrickMatch(expression,target)
		return compareFirst(expression,target) && (match(expression,target.drop(1)) || match(expression,target.drop(2)))
	end

	def bracketMatch(expression,target)
		endBracketIndex = findClosingBracket(expression,target)

	end

	def orMatch(expression,target)
		firstOr = expression.index("|")
		beforeOr = expression[0,firstOr]
		afterOr = expression[firstOr+1,expression.size]
		return match(beforeOr,target) || match(afterOr,target)
	end

	def compareFirst(expression,target)
		if target.empty? || target.empty?
			return false
		elsif expression == target
			return true
		elsif expression == "."
			return true
		else
			return false
		end
	end

	def findClosingBracket(expression,target)
		endBracket = 1
		i = 1;
		while i > 0
			c = expression[endBracket]
			if c == "("
				i = i+1
			elsif c == ")"
				i = i -1
			end
		end
		return endBracket
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
			elsif !correctasterick(expression)
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

# class Token
# 	$name = ""
# 	$value = ""
#
# 	def initialize(n,v)
# 		$name = n
# 		$value = v
# 	end
#
# end
#
# class Testing
# 	$pattern = ""
# 	$symbols = Hash.new()
# 	$current = 0
# 	$length = 0;
#
# 	def initialize(p)
# 		$pattern = p;
# 		$symbols = { "(" => "LEFT_PAREN" , ")" => "RIGHT_PAREN", "*" => "AST", "|" => "OR", "." => "DOT"}
# 		$current = 0;
# 		$length = p.length
# 	end
#
# 	def get_token
# 		if $current < $length
# 			cur = $pattern[$current]
# 			$current = $current + 1
#
# 			if !$symbols.has_key?(cur)
# 				return new Token("CHAR",cur)
# 			else
# 				return new Token([cur],cur)
# 			end
# 		else
# 			return Token("NONE","")
# 		end
# 	end
# end
#
