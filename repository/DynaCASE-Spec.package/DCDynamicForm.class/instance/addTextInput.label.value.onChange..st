adding
addTextInput: aName label: aLabel value: aString onChange: aOneArgBlock
	self
		addTextField: aName
		control: self newTextInput
		label: aLabel
		value: aString
		onChange: aOneArgBlock