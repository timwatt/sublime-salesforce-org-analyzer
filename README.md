# Salesforce Org Analyzer for Sublime

## Installation Instructions 
* Make sure you have Sublime Text and Package Control installed (https://packagecontrol.io/installation)
* Open the command prompt in Sublime Text (ctrl+shift+p (Win, Linux) or cmd+shift+p (OS X)) and type "Package Control: Add Repository"
* Copy the associated gihub url: https://github.com/timwatt/sublime-salesforce-org-analyzer/
* Open the command prompt in Sublime Text and type "Package Control: Install Package"
* Type "sublime-salesforce-org-analyzer" and select from the list
* Restart sublime


## Usage
* "Salesforce Org Analyzer" menu is now added to your toolbar
* The Sublime editor needs to be open to a folder. This plugin will add a couple of additional subdirectories to that folder: outputs and tests. Nothing needs to be in the open folder for the plugin to reference.
* On first run, you will be prompted for your credentials which will be stored in a file called org.properties in the open folder.

The core utilties are:
  - Security Audit:Executes a series of cucumber tests to validate various Salesforce org security settings
  - Health Check: Executes the security audit cucumber tests as well as other non-security related tests
  - Generate Documentation: Generates pdf verison of Salesforce org configuration ('config workbook')

## Run Ant scripts directly
* If you do not wish to use sublime, you can call the ant build.xml file directly
* From the folder you wish the output files should be written you can call the ant build.xml along with the appropriate target:   If I'm currently in /clients/proj1
   ant -f /path/to/salesforce-org-analyzer/build.xml security-audit
  will create the outputs & tests folders in /clients/proj1
*The ant targets are: security-audit, health-check, generate-doc

## From Eclipse
 - Goto Run > External Tools > External Tools Configuration
 - Right click on Ant Build and select New
 - Set the Name
 - Set the Buildfile to the build.xml file 
 - Set the Base directory to the variable "build_project" or whever you would like the files stored
 - Click on Targets tab
 - Select the appropriate target
 - Click Run
