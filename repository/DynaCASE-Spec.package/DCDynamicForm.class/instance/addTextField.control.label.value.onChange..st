adding
addTextField: aName control: aControl label: aLabel value: aString onChange: aOneArgBlock
	self addLabel: aName , 'Label' value: aLabel.
	aControl autoAccept: true.
	aControl text: aString.
	aControl
		whenTextChanged: [ :newValue | 
			aOneArgBlock value: newValue.
			self accepted ].
	components add: (Array with: aName with: aControl).
	self focusOrder add: aControl