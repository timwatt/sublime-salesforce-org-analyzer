Feature:  Limit access to API as appropriate

@security @healthcheck
Scenario: All Customer Community Member profiles should not have API access 
	Given all profiles with license type of "Customer Community" 
	Then the user permission "ApiEnabled" should be set to "false"

@security @healthcheck
Scenario: All Customer Community profiles should not have direct access to Apex classes
	Given all profiles with license type of "Customer Community" 
	Then the user "should not" have access to any Apex 

@security @healthcheck
Scenario: External sharing model is set up to reduce access
	Then all objects should have "external" visiblity set to "Private"