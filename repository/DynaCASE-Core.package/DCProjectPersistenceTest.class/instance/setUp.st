running
setUp
	super setUp.
	persistence := DCProjectDirectoryPersistence new.
	DCPluginRegistry setDefault: (DCPluginRegistry new add: DCTestPlugin new)