public - adding
addEntity: aName
	| control |
	self addLabel: aName.
	control := self instantiate: OPSelectEntity.
	self addControl: control.
	^ control