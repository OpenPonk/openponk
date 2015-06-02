hooks
buildEditorForm: aForm
	super buildEditorForm: aForm.

	aForm
		addTextInput: 'startMultiplicity'
		label: 'startMultiplicity'
		value: self model startMultiplicity 
		onChange: [ :newValue | self model startMultiplicity: newValue ].
	
	aForm
		addTextInput: 'endMultiplicity'
		label: 'endMultiplicity'
		value: self model endMultiplicity 
		onChange: [ :newValue | self model endMultiplicity: newValue ].
