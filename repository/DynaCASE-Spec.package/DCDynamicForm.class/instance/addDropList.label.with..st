adding
addDropList: aName label: aLabel with: aOneArgBlock
	| control |
	self addLabel: aName , 'Label' value: aLabel.
	control := self newDropList.
	aOneArgBlock value: control.
	components add: (Array with: aName with: control)