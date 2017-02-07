tests
testWriteModel
	| folder memento |
	folder := FileSystem memory root / 'models'.
	folder ensureCreateDirectory.
	memento := OPPersistenceMemento
		model: (OPNamedElement named: 'Item')
		diagram: {(#Item -> 1)} asDictionary.
	persistence saveMemento: memento to: folder with: OPStonSerializer new.
	self assert: (folder / memento uuid asString) isDirectory.
	self
		assert: (folder / memento uuid asString / 'model.ston') contents
		equals: (STON toStringPretty: memento model).
	self
		assert: (folder / memento uuid asString / 'diagram.ston') contents
		equals: (STON toStringPretty: memento diagram)