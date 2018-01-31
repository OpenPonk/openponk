opening
openFormOn: aController
	self class layoutStyle = #combined
		ifTrue: [ focusedEditor openFormOn: aController ]
		ifFalse: [ formModel editController: aController ]