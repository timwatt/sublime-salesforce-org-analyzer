Feature: Sensitive information is locked down

@security @healthcheck
Scenario: User credentials should not be stored in Custom Settings (use named credentials)
	Given all custom settings that contain credentials
	Then objects should be in the validated list
	 | name | reason |
	 
#Scenario: As a Customer Community Member potentially sensitive fields are not readable
#	Given a "Household Member" 
	#Given all fields whose name may indicate sensitive data
#	Then the fields "should not" be "readable"