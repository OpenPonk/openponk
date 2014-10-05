adding
addTextArea: aName label: aLabel value: aString onChange: aOneArgBlock
	| control |
	self addLabel: aName , 'Label' value: aLabel.
	control := self newText.
	control autoAccept: true.
	control text: aString.
	control whenTextChanged: [ :newValue | aOneArgBlock value: newValue ].
	components add: (Array with: aName with: control)