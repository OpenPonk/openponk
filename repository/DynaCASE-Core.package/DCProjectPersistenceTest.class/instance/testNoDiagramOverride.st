tests
testNoDiagramOverride
	| model folder memento contents |
	folder := FileSystem memory root / 'models'.
	model := DCNamedElement new.
	memento := DCPersistenceMemento model: model diagram: {(#Item -> 1)} asDictionary.
	persistence saveMemento: memento to: folder with: DCStonSerializer new.
	contents := (folder / memento uuid asString / 'diagram.ston') contents.
	memento := DCPersistenceMemento model: model diagram: nil.
	persistence saveMemento: memento to: folder with: DCStonSerializer new.
	self assert: (folder / memento uuid asString / 'diagram.ston') contents equals: contents