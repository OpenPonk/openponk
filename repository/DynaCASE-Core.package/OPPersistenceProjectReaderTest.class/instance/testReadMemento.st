tests
testReadMemento
	| memento |
	memento := reader
		readMementoFrom: root / 'models' / project models first uuid asString
		with: OPStonSerializer new.
	self assert: memento model className equals: project models first className.
	self assert: memento model name equals: project models first name.
	self assert: memento model uuid equals: project models first uuid.
	self assert: memento diagram equals: nil