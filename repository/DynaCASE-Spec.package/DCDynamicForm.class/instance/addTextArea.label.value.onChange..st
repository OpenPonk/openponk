adding
addTextArea: aName label: aLabel value: aString onChange: aOneArgBlock
	self
		addTextField: aName
		control: self newText
		label: aLabel
		value: aString
		onChange: aOneArgBlock