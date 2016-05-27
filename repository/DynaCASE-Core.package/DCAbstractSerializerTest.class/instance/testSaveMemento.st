running
testSaveMemento
	serializer saveMemento: memento to: root.
	self assert: (root / 'model' , serializer modelExtension) exists.
	self assert: (root / 'diagram' , serializer diagramExtension) exists