accessing
controller: aController
	controller := aController.
	self resetForm.
	controller ifNotNil: [ controller populateForm: self ]