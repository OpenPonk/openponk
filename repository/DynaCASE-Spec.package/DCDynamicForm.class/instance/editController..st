as yet unclassified
editController: aController
	components size > 0
		ifTrue: [ self reset ].
	aController ifNotNil: [ aController buildEditorForm: self ].
	self rebuildWidget.
	self takeKeyboardFocus