# salesforce-org-analyzer

# Pre-requisites
 - Java
 - Ant

# Instructions 
There are various tasks as part of the Ant build
  - security-audit:Executes a series of cucumber tests to validate various Salesforce org security settings
  - health-check: Executes the security audit cucumber tests as well as other non-security related tests
  - generate-doc: Generates pdf verison of Salesforce org configuration

For the test, clone the repository to your computer. From the command line, type "ant generate-doc". You will then be prompted for the credentials for your org. The ant script will run and will likely post a bunch of warnings but will still run.  When completed check the outputs folder where you should see a sub-folder for the "Client Name" that you entered and within that a pdf.


If using eclipse:
 - Goto Run > External Tools > External Tools Configuration
 - Right click on Ant Build and select New
 - Set the Name to "Generate Doc"
 - Set the Buildfile to the build.xml file in the unzipped folder
 - Set the Base director to the unzipped folder
 - Click on Targets tab
 - Make sure the "generate-doc" target is the only one selected
 - Click Run
