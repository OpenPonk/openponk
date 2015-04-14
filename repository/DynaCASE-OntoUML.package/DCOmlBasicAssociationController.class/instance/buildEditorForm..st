hooks
buildEditorForm: aForm
	super buildEditorForm: aForm.
	aForm
		addTextInput: 'sourceMultiplicity'
		label: 'Source multiplicity'
		value: self model startMultiplicity
		onChange: [ :newValue | 
			self model
				startMultiplicity: newValue;
				changed ].
	aForm
		addTextInput: 'targetMultiplicity'
		label: 'Target multiplicity'
		value: self model endMultiplicity
		onChange: [ :newValue | 
			self model
				endMultiplicity: newValue;
				changed ]