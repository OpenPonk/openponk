running
setUp
	super setUp.
	serializer := self serializerClass new.
	root := FileSystem memory.
	memento := DCPersistenceMemento
		model: DCNamedElement new
		diagram: {('1' -> '2')} asDictionary