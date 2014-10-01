initialization
resetForm
	whenNameFieldChanged := [ :newValue |  ].
	whenTextFieldChanged := [ :aText |  ].
	nameField text: ''.
	textField text: ''