initialization
initialize
	pluginRegistry := OPPluginRegistry default.
	editors := IdentityDictionary new.
	super initialize