public
editController: aController
	components ifNotEmpty: [ self reset ].
	controller := aController.
	controller ifNotNil: [ controller buildEditorForm: self ].
	self
		rebuildWidget;
		takeKeyboardFocus