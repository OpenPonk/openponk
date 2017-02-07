running
setUp
	super setUp.
	OPPluginRegistry setDefault: (OPPluginRegistry new add: OPTestPlugin new).
	reader := OPPersistenceProjectReader new.
	self setUpBasicProject