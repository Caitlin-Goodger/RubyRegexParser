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
	def self.completeMatching(expression, target)
		if (expression.nil? || expression.empty?) && (target.nil? || target.empty?)
			return true
		elsif expression[1] == "*"
			return astrickMatch(expression, target)
		elsif expression[0] == "("
			return bracketMatch(expression, target)
		elsif expression.include?("|")
			return orMatch(expression, target)
		else
			return compareFirst(expression[0], target[0]) && completeMatching(expression.drop(1), target.drop(1))
		end
	end

	def self.astrickMatch(expression, target)
		compareFirst(expression[0], target[0]) && completeMatching(expression, target.drop(1)) || completeMatching(expression.drop(2), target)
	end

	def self.bracketMatch (expression, target)
		endBracketIndex = findEndBracket(expression)
		bracket = expression[1, endBracketIndex-1]
		if bracket.last == "*"
			return false
		end
		if expression[endBracketIndex + 1] == "*"
			left = expression.drop(endBracketIndex + 2)
			if bracket.include?("|") && findOrIndex(bracket) != 99
				orIndex = findOrIndex(bracket)
				beforeOr = bracket[0, orIndex]
				afterOr = bracket[orIndex+1, bracket.size]
				(completeMatching(beforeOr, target[0, beforeOr.size]) && completeMatching(expression, target.drop(beforeOr.size))) || completeMatching(left, target) ||
					(completeMatching(afterOr, target[0, afterOr.size]) && completeMatching(expression, target.drop(afterOr.size))) || completeMatching(left, target)

			else
				(completeMatching(bracket, target[0, bracket.size]) && completeMatching(expression, target.drop(bracket.size))) || completeMatching(left, target)
			end
		elsif bracket.include?("|") && findOrIndex(bracket) != 99
			left = expression.drop(endBracketIndex + 1)
			orIndex = findOrIndex(bracket)
			beforeOr = bracket[0, orIndex]
			afterOr = bracket[orIndex+1, bracket.size]
			completeMatching(beforeOr, target[0, beforeOr.size]) && completeMatching(left, target.drop(beforeOr.size)) ||
				completeMatching(afterOr, target[0, afterOr.size]) && completeMatching(left, target.drop(afterOr.size))
		else
			left = expression.drop(endBracketIndex + 1)
			inside = bracket - ["("] - [")"]
			#puts bracket
			#puts inside
			completeMatching(bracket, target[0, inside.size]) && completeMatching(left, target.drop(inside.size))
		end
	end

	def self.orMatch(expression, target)
		orIndex = expression.index("|")
		beforeOr = expression[0, orIndex]
		afterOr = expression[orIndex+1, expression.size]
		completeMatching(beforeOr, target) || completeMatching(afterOr, target)
	end

	def self.compareFirst(expression, target)
		if target.nil? || target.empty?
			return false
		elsif expression == "."
			return true
		elsif expression == target
			return true
		else
			return false
		end
	end

	def self.findEndBracket(expression)
		endBracket = 0
		i = 1
		while i > 0
			endBracket += 1
			c = expression[endBracket]
			if c == "("
				i += 1
			elsif c == ")"
				i -= 1
			elsif endBracket == 99
				break
			end
		end
		endBracket
	end

	def self.findOrIndex(expression)
		orIndex = -1
		i = 1
		while i > 0
			orIndex += 1
			c = expression[orIndex]
			if c == "("
				i += 1
			elsif c == ")"
				i -= 1
			elsif c == "|"
				return orIndex
			elsif orIndex == 99
				return orIndex
				break
			end
		end
	end

	if ARGV.size < 2
		puts "Too few arguments"
		exit
	elsif ARGV.size > 2
		puts "Too many arguments"
		exit
	elsif ARGV.size == 2
		expressions = ARGV[0]
		targets = ARGV[1]

		begin
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
			# if target == expression
			# 	puts "YES: " + expression +  " with " + target + "\n"
			# 	output.write("YES: " + expression +  " with " + target + "\n")
			if !evenBrackets(expression)
				puts "SYNTAX ERROR: " + expression +  " with " + target + "\n"
				output.write("SYNTAX ERROR: " + expression +  " with " + target + "\n")
			elsif !correctasterick(expression)
				puts "SYNTAX ERROR: " + expression +  " with " + target + "\n"
				output.write("SYNTAX ERROR: " + expression +  " with " + target + "\n")
			else
				if completeMatching(expression.chars, target.chars)
					puts "YES: " + expression +  " with " + target + "\n"
					output.write("YES: " + expression +  " with " + target + "\n")
				else
					#l = Lex.new(expression)
					#puts l.get_token()
					puts "NO: " + expression +  " with " + target + "\n"
					output.write("NO: " + expression +  " with " + target + "\n")
				end
			end
		}
		exFile.close
		tarFile.close
		rescue
			puts "Arguments given are not files"
		end

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
