running
setUp
	super setUp.
	persistence := OPProjectDirectoryPersistence new.
	OPPluginRegistry setDefault: (OPPluginRegistry new add: OPTestPlugin new)