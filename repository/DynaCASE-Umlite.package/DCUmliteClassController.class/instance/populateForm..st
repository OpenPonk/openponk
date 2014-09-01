as yet unclassified
populateForm: aForm
	aForm nameField text: self model name.
	aForm nameField whenTextChanged: [ :newValue | self model name: newValue ].
	aForm textField text: self model attributes asStringWithCr.
	aForm textField whenTextChanged: [ :aText | self model attributes: aText asString trim lines ]