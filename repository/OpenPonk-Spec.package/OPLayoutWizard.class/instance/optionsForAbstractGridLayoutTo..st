options
optionsForAbstractGridLayoutTo: aPane
	aPane
		addPart:
			(TextFieldPart new
				inGroupboxNamed: 'Gap size';
				defaultValue: '50';
				transformed: toNumberBlock)
		associatedTo: #perform_gapSize.
	aPane
		condition: [ :dict | NumberParser isNumber: (dict at: #perform_gapSize) ]
		named: 'Gap size must be a number.'