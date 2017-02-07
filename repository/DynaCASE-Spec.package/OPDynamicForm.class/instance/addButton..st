public - adding
addButton: aName
	| control |
	control := self newButton.
	control label: aName.

	self addControl: control.
	^ control