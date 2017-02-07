reading
readModelReference: anId plugin: aName pluginVersion: aVersion
	| plugin |
	plugin := OPPluginRegistry default plugins
		detect: [ :each | each className = aName ]
		ifNone: [ ^ self error: 'Unrecognized plugin ' , aName ].
	self flag: 'todo: version comparison'.
	^ plugin