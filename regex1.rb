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
		if expression == target
			puts "YES: " + expression +  " with " + target + "\n"
			output.write("YES: " + expression +  " with " + target + "\n")
		else
			puts "NO:" + "\n"
			output.write("NO:" + "\n")
		end
	}
	exFile.close
	tarFile.close
end
