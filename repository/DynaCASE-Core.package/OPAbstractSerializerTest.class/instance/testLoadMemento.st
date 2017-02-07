running
testLoadMemento
	| newMemento |
	serializer saveMemento: memento to: root.
	newMemento := serializer loadMementoFrom: root.
	self deny: newMemento == memento.
	self assert: newMemento uuid equals: memento uuid.
	self assert: newMemento diagram equals: memento diagram