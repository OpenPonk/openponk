hooks
buildEditorForm: aForm
	aForm
		addTextInput: 'name'
		label: 'Name'
		value: self model name
		onChange: [ :newValue | self model name: newValue ]