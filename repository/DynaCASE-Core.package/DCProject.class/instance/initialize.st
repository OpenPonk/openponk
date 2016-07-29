initialization
initialize
	models := OrderedCollection new asValueHolder.
	state := Dictionary new.
	layouts := Dictionary new.
	projectName := NewValueHolder value: 'Unnamed project'.
	dirty := false asValueHolder.
	models whenChangedDo: [ self beDirty ].
	projectName whenChangedDo: [ self beDirty ]