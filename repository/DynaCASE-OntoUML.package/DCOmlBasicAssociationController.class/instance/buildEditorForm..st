hooks
buildEditorForm: aForm
	aForm
		addTextInput: 'name'
		label: 'name'
		value: self model name
		onChange: [ :newValue | self model name: newValue ].

	aForm
		addTextInput: 'sourceMultiplicity'
		label: 'source multiplicity'
		value: self model startMultiplicity
		onChange: [ :newValue | 
			self model startMultiplicity: newValue.
			self model changed ].

	aForm
		addTextInput: 'targetMultiplicity'
		label: 'target multiplicity'
		value: self model endMultiplicity
		onChange: [ :newValue | 
			self model endMultiplicity: newValue.
			self model changed ]