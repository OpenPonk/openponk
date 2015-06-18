public - adding
addLabel: aLabel
	| control |
	control := self newLabel.
	control
		label: aLabel;
		emphasis: 1.

	self addControl: control.
	^ control