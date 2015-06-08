class BestPracticeViolatedError < StandardError
	attr_reader :matches
	def initialize(matches)
		super("The following items violated the best practice: \n  - " + matches.join("\n  - ") + "\n\n")
		@matches = matches
	end
end