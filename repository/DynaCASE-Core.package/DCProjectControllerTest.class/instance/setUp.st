running
setUp
	controller := DCProjectController new.
	project := DCProject new.
	controller project: project.
	DCPluginRegistry setDefault: (DCPluginRegistry new add: DCTestPlugin new)