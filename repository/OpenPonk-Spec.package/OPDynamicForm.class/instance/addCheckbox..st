public - adding
addCheckbox: aName
	| control |
	control := self newCheckBox.
	control label: aName.

	self addControl: control.
	^ control