public - adding
addText: aName
	| control |
	self addLabel: aName.

	control := self newText.
	control autoAccept: true.

	self addControl: control.
	^ control