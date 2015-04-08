as yet unclassified
editController: aController
	components ifNotEmpty: [ self reset ].
	aController ifNotNil: [ aController buildEditorForm: self ].
	self
		rebuildWidget;
		takeKeyboardFocus