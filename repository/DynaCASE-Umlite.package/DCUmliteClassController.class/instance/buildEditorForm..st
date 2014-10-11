as yet unclassified
buildEditorForm: aForm
	aForm
		addTextInput: 'name'
		label: 'name'
		value: self model name
		onChange: [ :newValue | self model name: newValue ].

	aForm
		addTextArea: 'attrs'
		label: 'attributes'
		value: self model attributes asStringWithCr
		onChange: [ :newValue | self model attributes: newValue asString lines ]