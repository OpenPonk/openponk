options
optionsForAbstractRegularTreeLayoutTo: aPane
	aPane
		addPart:
			(CheckboxPart new
				inGroupboxNamed: 'Layered';
				label: 'Is layered';
				defaultValue: false)
		associatedTo: #perform_isLayered