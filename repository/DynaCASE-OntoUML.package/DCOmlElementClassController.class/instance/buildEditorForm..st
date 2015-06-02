hooks
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
		onChange: [ :newValue | self parseAttributes: newValue ].
	aForm
		addTextArea: 'methods'
		label: 'methods'
		value: self model methods asStringWithCr
		onChange: [ :newValue | self parseMethods: newValue ]