public - adding
addTextInput: aName
	| control |
	self addLabel: aName.

	control := self newTextInput.
	control autoAccept: true.

	self addControl: control.
	^ control