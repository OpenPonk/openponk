accessing
plugin
	^ plugin ifNil: [ DCPluginRegistry default pluginForController: self ]