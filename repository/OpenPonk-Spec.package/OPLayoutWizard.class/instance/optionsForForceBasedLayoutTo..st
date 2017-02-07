options
optionsForForceBasedLayoutTo: aPane
	aPane
		addPart:
			(TextFieldPart new
				inGroupboxNamed: 'Charge';
				defaultValue: '-300';
				transformed: toNumberBlock)
		associatedTo: #perform_charge.
	aPane
		condition: [ :dict | NumberParser isNumber: (dict at: #perform_charge) ]
		named: 'Charge must be a number.'