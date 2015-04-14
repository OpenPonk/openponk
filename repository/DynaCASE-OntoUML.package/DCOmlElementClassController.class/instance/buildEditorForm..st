hooks
buildEditorForm: aForm
	super buildEditorForm: aForm.
	aForm
		addTextArea: 'attrs'
		label: 'Attributes'
		value: self model attributes asStringWithCr
		onChange: [ :newValue | self model attributes: newValue asString lines ].
	aForm
		addTextArea: 'methods'
		label: 'Methods'
		value: self model methods asStringWithCr
		onChange: [ :newValue | self model methods: newValue asString lines ]