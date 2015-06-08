Feature: VF best practices are followed

@healthcheck	
Scenario: Stylesheets should be stored as Static Resources and referenced by VF pages instead of inline style tags
	Given all Visualforce pages
	Then the contents of the "page" "should not" include the text "<style>" 

@healthcheck	
Scenario: Stylesheets should stored as Static Resources and referenced by VF components instead of inline style tags
	Given all Visualforce components
	Then the contents of the "components" "should not" include the text "<style>" 

@security @healthcheck	
Scenario: Any use of Visualforce Remoting in VF pages has been validated to prevent SOQL injection
	Given all Visualforce pages
	Then the contents of the "page" "should not" include the text "Visualforce.Remoting" 

@security @healthcheck	
Scenario: Any use of Visualforce Remoting in VF components has been validated to prevent SOQL injection
	Given all Visualforce components
	Then the contents of the "component" "should not" include the text "Visualforce.Remoting" 
