public - adding
addEntity: aName
	| control |
	self addLabel: aName.
	control := self instantiate: DCSelectEntity.
	self addControl: control.
	^ control