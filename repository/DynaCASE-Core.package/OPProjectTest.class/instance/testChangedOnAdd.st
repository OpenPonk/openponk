tests
testChangedOnAdd
	| project diagram changed element |
	true
		ifTrue: [ self skip: 'CI has strange issues with announcements.' ].
	changed := false.
	project := OPProject new.
	project whenChanged: [ changed := true ].
	self deny: changed.

	changed := false.
	project projectName: 'Project name'.
	self assert: changed.

	changed := false.
	diagram := OPDiagram new.
	project addModel: diagram.
	self assert: changed.

	changed := false.
	element := OPNamedElement new.
	diagram add: element.
	self assert: changed.

	changed := false.
	element name: 'a name'.
	self assert: changed