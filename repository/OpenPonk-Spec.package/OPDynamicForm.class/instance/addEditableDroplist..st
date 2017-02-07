public - adding
addEditableDroplist: aName
	| control |
	self addLabel: aName.
	control := self instantiate: OPEditableDropListModel.
	self addControl: control.
	^ control