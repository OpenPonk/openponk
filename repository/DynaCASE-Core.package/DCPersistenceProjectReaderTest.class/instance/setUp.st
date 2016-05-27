running
setUp
	super setUp.
	DCPluginRegistry setDefault: (DCPluginRegistry new add: DCTestPlugin new).
	reader := DCPersistenceProjectReader new.
	self setUpBasicProject