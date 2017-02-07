tests
testChangedOnRemove
	| project diagram changed element |
	true
		ifTrue: [ self skip: 'CI has strange issues with announcements.' ].
	project := OPProject new.
	diagram := OPDiagram new.
	element := OPNamedElement new.
	project whenChanged: [ changed := true ].
	project addModel: diagram.
	diagram add: element.

	changed := false.
	project removeModel: diagram.
	self assert: changed.

	changed := false.
	diagram name: 'new name'.
	self deny: changed.

	changed := false.
	element name: 'changed'.
	self deny: changed