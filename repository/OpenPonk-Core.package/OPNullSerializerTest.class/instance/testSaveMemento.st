running
testSaveMemento
	serializer saveMemento: memento to: root.
	self deny: (root / 'model' , serializer modelExtension) exists.
	self deny: (root / 'diagram' , serializer diagramExtension) exists