actions
removeView: aView
	(UIManager default
		confirm: 'Are you sure you want to remove view ' , (self displayFor: aView) , '?')
		ifFalse: [ ^ self ].
	self workbench closeEditorOf: aView.
	aView project: nil.
	self updateContent