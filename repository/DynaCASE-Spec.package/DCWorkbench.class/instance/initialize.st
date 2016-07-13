initialization
initialize
	pluginRegistry := DCPluginRegistry default.
	editors := IdentityDictionary new.
	super initialize