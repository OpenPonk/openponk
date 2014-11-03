hooks
buildEditorForm: aForm
	aForm
		addTextInput: 'stereotype'
		label: 'stereotype'
		value: self model stereotype
		onChange: [ :newValue | self model stereotype: newValue ].
	aForm
		addTextInput: 'name'
		label: 'name'
		value: self model name
		onChange: [ :newValue | self model name: newValue ].
	aForm
		addTextArea: 'attrs'
		label: 'attributes'
		value: self model attributes asStringWithCr
		onChange: [ :newValue | self model attributes: newValue asString lines ].
	aForm
		addTextArea: 'methods'
		label: 'methods'
		value: self model methods asStringWithCr
		onChange: [ :newValue | self model methods: newValue asString lines ]