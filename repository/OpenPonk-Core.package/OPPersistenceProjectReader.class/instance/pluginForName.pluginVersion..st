reading
pluginForName: aName pluginVersion: aVersion
	| plugin |
	plugin := OPPluginRegistry default plugins
		detect: [ :each | each className = aName and: [ each version = aVersion ] ]
		ifNone: [ ^ self error: 'Unrecognized plugin ' , aName , ' version ' , aVersion ].
	^ plugin