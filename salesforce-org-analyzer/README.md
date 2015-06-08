# salesforce-org-analyzer

# Pre-requisites
 - Java
 - Ant

# Instructions 
There are various tasks as part of the Ant build
  - security-audit:Executes a series of cucumber tests to validate various Salesforce org security settings
  - health-check: Executes the security audit cucumber tests as well as other non-security related tests
  - generate-doc: Generates pdf verison of Salesforce org configuration
