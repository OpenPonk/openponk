initialization
initializePresenter
	super initializePresenter.
	self resetForm.
	self nameField whenTextChanged: [ :newValue | whenNameFieldChanged value: newValue ].
	self textField whenTextChanged: [ :aText | whenTextFieldChanged value: aText ]