running
setUp
	controller := OPProjectController new.
	project := OPProject new.
	controller project: project.
	OPPluginRegistry setDefault: (OPPluginRegistry new add: OPTestPlugin new)