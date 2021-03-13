if ARGV.length < 2
    puts "Too few arguments"
    exit
elsif ARGV.length > 2
    puts "Too many arguments"
    exit
elsif ARGV.length == 2
	expressions = ARGV[0]
	targets = ARGV[1]
	exLines = File.readlines(expressions)
	tarLines = File.readlines(targets)
	(0..exLines.size).each { |i|
		expression = exLines[i];
		target = tarLines[i];
		if expression == target
			puts "Yes"
		else
			puts "No"
		end
	}
end
