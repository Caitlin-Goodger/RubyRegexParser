class Regex1


	def initialize
		super
	end


	# Check that there an even number of opening and closing brackets
	def self.evenBrackets(expression,target)
		openBrackets = expression.count("(")
		closeBrackets = expression.count(")")
		return openBrackets == closeBrackets
	end

	# Check that there aren't astrisks in places there should be
	#  A regex can't start with *
	# And it can't come after an opening bracket or an or
	def self.correctasterick(expression,target)
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

	# Find the end bracket.
	# Count up all the opening brackets and once they are all closed then return the index of the next closing bracket
	# If that doesn't work and you keept going up without reaching 0, then return if you reach 42
	def self.findEndBracket(expression,target)
		endBracket = 0
		i = 1
		while i > 0
			endBracket = endBracket + 1
			c = expression[endBracket]
			if c == "("
				i = i + 1
			elsif c == ")"
				i = i - 1
			elsif endBracket == 42
				break
			end
		end
		return endBracket
	end


	# Main matching method.
	# Checks the first character of expression and performs parsing depending on what it is
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

	# Match for an astrisk
	# Look to see if the first characters match and then look at what comes after
	def self.astrickMatch(expression, target)
		return compareFirst(expression[0], target[0]) && completeMatching(expression, target.drop(1)) || completeMatching(expression.drop(2), target)
	end

	# Match for a bracket
	# Find the closing bracket and then look at what is inside the bracket
	# Depends on whether there is an * or an or
	def self.bracketMatch (expression, target)
		endBracketIndex = findEndBracket(expression,target)
		bracket = expression[1, endBracketIndex-1]
		if bracket.last == "*"
			return false
		end
		if expression[endBracketIndex + 1] == "*"
			left = expression.drop(endBracketIndex + 2)
			if bracket.include?("|")
				orIndex = bracket.index("|")
				beforeOr = bracket[0, orIndex]
				afterOr = bracket[orIndex+1, bracket.size]
				return (completeMatching(beforeOr, target[0, beforeOr.size]) && completeMatching(expression, target.drop(beforeOr.size))) || completeMatching(left, target) || (completeMatching(afterOr, target[0, afterOr.size]) && completeMatching(expression, target.drop(afterOr.size))) || completeMatching(left, target)

			else
				return (completeMatching(bracket, target[0, bracket.size]) && completeMatching(expression, target.drop(bracket.size))) || completeMatching(left, target)
			end
		elsif bracket.include?("|")
			left = expression.drop(endBracketIndex + 1)
			orIndex = bracket.index("|")
			beforeOr = bracket[0, orIndex]
			afterOr = bracket[orIndex+1, bracket.size]
			return completeMatching(beforeOr, target[0, beforeOr.size]) && completeMatching(left, target.drop(beforeOr.size)) || completeMatching(afterOr, target[0, afterOr.size]) && completeMatching(left, target.drop(afterOr.size))
		else
			left = expression.drop(endBracketIndex + 1)
			return completeMatching(bracket, target[0, bracket.size]) && completeMatching(left, target.drop(bracket.size))
		end
	end

	# Check for or
	# Look at both sides of the or and compare to see which matches the target
	def self.orMatch(expression, target)
		orIndex = expression.index("|")
		beforeOr = expression[0, orIndex]
		afterOr = expression[orIndex+1, expression.size]
		return completeMatching(beforeOr, target) || completeMatching(afterOr, target)
	end

	# Compare the first character of the expression and target to see if they match
	def self.compareFirst(expression, target)
		if target.nil? || target.empty?
			return false
		elsif expression == "." || expression == target
			return true
		else
			return false
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
			# output = File.open("output.txt","w")
			exFile = File.open(expressions)
			exLines = File.read(exFile).split("\n")
			tarFile = File.open(targets)
			tarLines = File.read(targets).split("\n")
		rescue
			puts "Arguments given are not files"
			exit
		end

		begin
			(0..exLines.size-1).each { |i|
				expression = exLines[i];
				target = tarLines[i];
				if !evenBrackets(expression,target)
					puts "SYNTAX ERROR: " + expression +  " with " + target + "\n"
					# output.write("SYNTAX ERROR: " + expression +  " with " + target + "\n")
				elsif !correctasterick(expression,target)
					puts "SYNTAX ERROR: " + expression +  " with " + target + "\n"
					# output.write("SYNTAX ERROR: " + expression +  " with " + target + "\n")
				else
					if completeMatching(expression.chars, target.chars)
						puts "YES: " + expression +  " with " + target + "\n"
						# output.write("YES: " + expression +  " with " + target + "\n")
					else
						puts "NO: " + expression +  " with " + target + "\n"
						# output.write("NO: " + expression +  " with " + target + "\n")
					end
				end
			}
			exFile.close
			tarFile.close
		rescue
			puts "Error parsing expression, please try again"
			exit
		end


	end
end

# I took some idea of how to create your own parsing from https://nickdrane.com/build-your-own-regex/. It gave me an idea of where to start this program and how to parse an expression

