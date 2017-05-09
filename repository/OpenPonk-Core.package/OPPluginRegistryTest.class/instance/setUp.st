initialization
setUp
	super setUp.
	registry := OPPluginRegistry new.
	registry add: OPTestPlugin new