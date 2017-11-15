reading
readModelReferences: aRootFolder
	| references |
	references := STON fromString: (aRootFolder / 'models.json') readStream.
	^ references
		collect: [ :each | 
			| uuid model |
			uuid := self modelIdFrom: (each at: 'uuid').
			model := self
				pluginForName: (each at: 'plugin')
				pluginVersion: (each at: 'pluginVersion').
			uuid -> model ]