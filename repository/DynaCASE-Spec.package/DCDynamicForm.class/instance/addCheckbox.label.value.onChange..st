adding
addCheckbox: aName label: aLabel value: aBoolean onChange: aOneArgBlock
	| control |
	control := self newCheckBox.
	control label: aLabel.
	control state: aBoolean.
	control whenChangedDo: aOneArgBlock.
	components add: (Array with: aName with: control)