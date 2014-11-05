tests
testChangedOnRemove
	| project diagram changed element |
	project := DCProject new.
	project whenChanged: [ changed := true ].
	diagram := DCDiagram new.
	project addDiagram: diagram.
	element := DCNamedElement new.
	diagram add: element.

	changed := false.
	project removeDiagram: diagram.
	"	self assert: changed"	"currently broken in Pharo - fix pending"

	changed := false.
	diagram name: 'new name'.
	self deny: changed.

	changed := false.
	element name: 'changed'.
	self deny: changed