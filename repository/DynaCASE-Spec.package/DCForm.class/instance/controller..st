accessing
controller: aController
	controller := aController.
	controller ifNotNil: [ controller populateForm: self ].
	controller
		ifNil: [ 
			self nameField
				text: '';
				whenTextChanged: [ :newValue |  ] ]