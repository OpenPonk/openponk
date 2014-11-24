hooks
buildEditorForm: aForm
	aForm
		addTextInput: 'name'
		label: 'name'
		value: self model name
		onChange: [ :newValue | self model name: newValue ].
	
	aForm
		addCheckbox: 'sharable'
		label: 'sharable'
		value: self model isShareable
		onChange: [ :newValue | self model shareable: newValue ]