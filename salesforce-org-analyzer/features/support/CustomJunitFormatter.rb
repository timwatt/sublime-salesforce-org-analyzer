require 'cucumber/formatter/junit'


module Cucumber::Formatter
	class CustomJUnit < Junit
		def format_exception(exception)
	      (["extra data"] + ["#{exception.message} (#{exception.class})"] + exception.backtrace).join("\n")
	    end
	end
end