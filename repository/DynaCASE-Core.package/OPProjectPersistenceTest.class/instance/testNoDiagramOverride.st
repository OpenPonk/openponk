tests
testNoDiagramOverride
	| model folder memento contents |
	folder := FileSystem memory root / 'models'.
	model := OPNamedElement new.
	memento := OPPersistenceMemento model: model diagram: {(#Item -> 1)} asDictionary.
	persistence saveMemento: memento to: folder with: OPStonSerializer new.
	contents := (folder / memento uuid asString / 'diagram.ston') contents.
	memento := OPPersistenceMemento model: model diagram: nil.
	persistence saveMemento: memento to: folder with: OPStonSerializer new.
	self assert: (folder / memento uuid asString / 'diagram.ston') contents equals: contents