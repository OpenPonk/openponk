tests
testChangedOnRemove
	| project diagram changed element |
	project := DCProject new.
	diagram := DCDiagram new.
	element := DCNamedElement new.
	project whenChanged: [ changed := true ].
	project addDiagram: diagram.
	diagram add: element.

	changed := false.
	project removeDiagram: diagram.
	self assert: changed.

	changed := false.
	diagram name: 'new name'.
	self deny: changed.

	changed := false.
	element name: 'changed'.
	self deny: changed