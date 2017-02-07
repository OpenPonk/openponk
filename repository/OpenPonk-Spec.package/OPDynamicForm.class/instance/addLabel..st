public - adding
addLabel: aLabel
	| control |
	control := self newLabel.
	control
		label: aLabel;
		emphasis: #(bold).

	self addControl: control.
	^ control