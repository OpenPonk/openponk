hooks
buildEditorForm: aForm
	aForm
		addTextInput: 'name'
		label: 'name'
		value: self model name
		onChange: [ :newValue | self model name: newValue ].

	aForm
		addTextInput: 'sourceName'
		label: 'source name'
		value: self model sourceName
		onChange: [ :newValue | self model sourceName: newValue ].

	aForm
		addTextInput: 'targetName'
		label: 'target name'
		value: self model targetName
		onChange: [ :newValue | self model targetName: newValue ]