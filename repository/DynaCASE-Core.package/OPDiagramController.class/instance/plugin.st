accessing
plugin
	^ plugin ifNil: [ OPPluginRegistry default pluginForController: self ]