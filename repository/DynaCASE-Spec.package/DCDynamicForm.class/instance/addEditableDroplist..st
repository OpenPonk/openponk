public - adding
addEditableDroplist: aName
	| control |
	self addLabel: aName.
	control := self instantiate: DCEditableDropListModel.
	self addControl: control.
	^ control