as yet unclassified
populateForm: aForm
	aForm nameFieldText: self model name.
	aForm whenNameFieldChanged: [ :newValue | self model name: newValue ].
	aForm textFieldText: self model attributes asStringWithCr.
	aForm whenTextFieldChanged: [ :aText | self model attributes: aText asString trim lines ]