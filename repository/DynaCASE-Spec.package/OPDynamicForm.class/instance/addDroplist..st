public - adding
addDroplist: aName
	| control |
	self addLabel: aName.
	
	control := self newDropList.

	self addControl: control.
	^ control