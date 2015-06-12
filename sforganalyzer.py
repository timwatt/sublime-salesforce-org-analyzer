import sublime, sublime_plugin, sys, os, zipfile
from xml.dom.minidom import parseString

def runAnt(self,target):
	directory = os.path.join(sublime.packages_path(), "sublime-salesforce-org-analyzer", "salesforce-org-analyzer")
	self.build_file =os.path.join(directory, "build.xml")

	if not os.path.exists(directory):
		sys.stdout.write(os.path.splitext(__file__)[1])
		if os.path.splitext(__file__)[1] == 'sublime-package':
			fh = open(os.path.dirname(os.path.realpath(__file__)), 'rb')
			z = zipfile.ZipFile(fh)
			z.extractAll(directory)
			fh.close()

	print("Selected target: " + target)

	build_system = "ant"

	if sys.platform.startswith("win32"):
		build_system = "ant.bat"

	command = {
		"cmd": [
			build_system,
			"-f",
			self.build_file,
			target
		],
		"working_dir": sublime.active_window().folders()[0],
	}

	try:
		self.view.window().run_command("exec", command)
		if target=="security-audit" or target=="health-check":
			results =  os.path.join(sublime.active_window().folders()[0], "outputs", target, "results.txt")
			sublime.active_window().open_file(results)
	except Exception as ex:
		sublime.status_message("Error running ANT build: " + ex)

class GenerateDocCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		runAnt(self,"generate-doc")

class SecurityAuditCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		runAnt(self,"security-audit")
		
class HealthCheckCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		runAnt(self,"health-check")

class ReloadMetadataCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		runAnt(self,"generate-metadata")