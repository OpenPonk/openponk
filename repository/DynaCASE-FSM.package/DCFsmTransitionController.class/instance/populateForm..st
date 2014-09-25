hooks
populateForm: aForm
	aForm nameFieldText: self model name.
	aForm whenNameFieldChanged: [ :newValue | self model name: newValue ]