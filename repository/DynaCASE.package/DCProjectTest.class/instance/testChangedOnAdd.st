tests
testChangedOnAdd
	| project diagram changed element |
	true
		ifTrue: [ self skip: 'CI has strange issues with announcements.' ].
	changed := false.
	project := DCProject new.
	project whenChanged: [ changed := true ].
	self deny: changed.

	changed := false.
	project projectName: 'Project name'.
	self assert: changed.

	changed := false.
	diagram := DCDiagram new.
	project addDiagram: diagram.
	self assert: changed.

	changed := false.
	element := DCNamedElement new.
	diagram add: element.
	self assert: changed.

	changed := false.
	element name: 'a name'.
	self assert: changed