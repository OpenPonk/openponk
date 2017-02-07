running
setUp
	super setUp.
	serializer := self serializerClass new.
	root := FileSystem memory.
	memento := self newMemento