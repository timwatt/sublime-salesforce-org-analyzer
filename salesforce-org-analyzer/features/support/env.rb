require 'rspec/expectations'

def expectNoMatches matches 
	if (matches.count > 0)
		if (matches.instance_of? Array)
			raise BestPracticeViolatedError.new(matches)
		elsif matches.instance_of? Hash
			raise BestPracticeViolatedError.new(matches.keys)
		end
	end
end
