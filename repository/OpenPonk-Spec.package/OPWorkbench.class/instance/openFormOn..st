opening
openFormOn: aController
	useEditorForm
		ifTrue: [ focusedEditor openFormOn: aController ]
		ifFalse: [ formModel editController: aController ]