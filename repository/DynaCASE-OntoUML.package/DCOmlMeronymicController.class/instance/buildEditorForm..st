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
		onChange: [ :newValue | self model shareable: newValue ].

	aForm
		addCheckbox: 'essential'
		label: 'essential'
		value: self model isEssential
		onChange: [ :newValue | self model essential: newValue ].

	aForm
		addCheckbox: 'inseparable'
		label: 'inseparable'
		value: self model isInseparable
		onChange: [ :newValue | self model inseparable: newValue ].

	aForm
		addCheckbox: 'immutablePart'
		label: 'immutablePart'
		value: self model isImmutablePart
		onChange: [ :newValue | self model immutablePart: newValue ].

	aForm
		addCheckbox: 'immutableWhole'
		label: 'immutableWhole'
		value: self model isImmutableWhole
		onChange: [ :newValue | self model immutableWhole: newValue ]