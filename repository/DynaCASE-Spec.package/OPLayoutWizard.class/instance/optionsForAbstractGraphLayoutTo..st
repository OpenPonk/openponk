options
optionsForAbstractGraphLayoutTo: aPane
	aPane
		addPart:
			(TextFieldPart new
				inGroupboxNamed: 'Horizontal gap';
				defaultValue: '50';
				transformed: toNumberBlock)
		associatedTo: #perform_horizontalGap.
	aPane
		addPart:
			(TextFieldPart new
				inGroupboxNamed: 'Vertical gap';
				defaultValue: '50';
				transformed: toNumberBlock)
		associatedTo: #perform_verticalGap.
	aPane
		condition: [ :dict | NumberParser isNumber: (dict at: #perform_horizontalGap) ]
		named: 'Horizontal gap must be a number.'.
	aPane
		condition: [ :dict | NumberParser isNumber: (dict at: #perform_verticalGap) ]
		named: 'Vertical gap must be a number.'