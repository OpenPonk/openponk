writing
writeObject: anObject
	| mapping |
	mapping := self mappingFor: anObject class.
	mapping sortProperties.
	mapping
		writeObject: anObject
		on: self