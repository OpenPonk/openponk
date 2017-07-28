initialization
initialize
	uuid := UUID new.
	models := OrderedCollection new asValueHolder.
	state := Dictionary new.
	layouts := Dictionary new.
	name := NewValueHolder value: 'Unnamed project'.
	dirty := false asValueHolder.
	models whenChangedDo: [ dirty value: true ].
	name whenChangedDo: [ dirty value: true ]