class String
	def matches_pii?
		self.downcase.include?('birth') || self.downcase.include?('social') || self.downcase.include?('ssn')
	end
	def matches_phi?
	end

	def matches_credentials?
		self.downcase.include?('password') || self.downcase.include?('pwd') || self.downcase.include?('username')
	end
end