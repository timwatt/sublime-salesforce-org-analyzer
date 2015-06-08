#require 'nokogiri'
require 'pathname'
require 'sfmetadata'

class Salesforce
	def self.client
		if @client.nil?
			@client = SfMetadata::Client.new
			@client.load_from_org_or_file(ENV["user_name"], ENV["password"] + ENV["security_token"], ENV["is_sandbox"], ENV["src_path"])    
	end
		@client
	end

	def profile
	#	@profile = Nokogiri::XML(File.open(@actor.profile_path)) if @profile.nil?
		@profile
	end

	def self.profiles
		if @profiles.nil?
			@profiles=@client.get_profiles
		end
		@profiles
	end

	def self.profiles_by_license_type
		if @profilesByLicenseType.nil?
			@profilesByLicenseType=@client.get_profiles_by_license
		end
		@profilesByLicenseType
	end
	def self.sobjects
		if @sobjects.nil?
			@sobjects = client.getSObjects
		end
		@sobjects
	end

	def self.custom_settings
		if @custom_settings.nil?
			@custom_settings=Hash.new
				@custom_settings=@client.get_custom_settings
		end
		@custom_settings
	end

	def self.apex_classes
		if @apex_classes.nil?
			@apex_classes = client.get_apex_classes
		end
		@apex_classes
	end

	def self.apex_triggers
		if @apex_triggers.nil?
			@apex_triggers = client.get_apex_triggers
		end
		@apex_triggers
	end

	def self.apex_pages
		if @apex_pages.nil?
			@apex_pages = client.get_visualforce_pages
		end
		@apex_pages
	end

	def self.apex_components
		if @apex_components.nil?
			@apex_components = client.get_visualforce_components
		end
		@apex_components
	end
end