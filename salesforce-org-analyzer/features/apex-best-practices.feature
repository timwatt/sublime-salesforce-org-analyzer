Feature: Apex best practices are followed

@security 
Scenario: Use of "with sharing" in Apex should always be used unless exception is documented (excluding classes that contain "getParameters" so they aren't double counted)
	Given Apex classes that do not have "getParameters"
  	Then the contents of the "class" "should" include the text "with sharing" 

@security @healthcheck	
Scenario: Classes that don't reference "with sharing" should only rely on parameters if the code has been validated to prevent SOQL injection
	Given Apex classes that do not have "with sharing" 
	Then the contents of the "class" "should not" include the text "getParameters" 

@security @healthcheck
Scenario: Any use of Database.query has been validated to prevent SOQL injection
	Given all Apex classes 
	Then the contents of the "class" "should not" include the text "Database.query" 

@healthcheck
Scenario: All test classes contain assertions
	Given all Apex classes that contain test methods
	Then the contents of the "class" "should" include the text "assert" 

@healthcheck
Scenario: There is only one trigger per object
	Given all Apex triggers
	Then there is only one trigger per object

@healthcheck
Scenario: All Apex classes that contain DML include exception handling
	Given all Apex classes that contain DML statements
	Then the contents of the "class" "should" include the text "catch" 