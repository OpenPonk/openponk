reading
readAllMementosFrom: aRootFolder
	| references |
	references := self readModelReferences: aRootFolder.
	^ references
		collect: [ :pair | 
			self
				readMementoFrom: aRootFolder / 'models' / pair key asString
				with: pair value serializerClass new ]