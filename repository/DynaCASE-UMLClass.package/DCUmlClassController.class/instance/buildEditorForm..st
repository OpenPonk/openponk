as yet unclassified
buildEditorForm: aForm
	aForm
		addTextInput: 'stereotype'
		label: 'Stereotype'
		value: self model stereotype
		onChange: [ :newValue | self model stereotype: newValue ].
	aForm
		addTextInput: 'name'
		label: 'Name'
		value: self model name
		onChange: [ :newValue | self model name: newValue ].
	aForm
		addTextArea: 'attrs'
		label: 'Attributes'
		value: self model attributes asStringWithCr
		onChange: [ :newValue | self model attributes: newValue asString lines ].
	aForm
		addTextArea: 'methods'
		label: 'Operations'
		value: self model operations asStringWithCr
		onChange: [ :newValue | self model operations: newValue asString lines ]