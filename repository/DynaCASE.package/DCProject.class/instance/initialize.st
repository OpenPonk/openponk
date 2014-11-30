initialization
initialize
	diagrams := OrderedCollection new asValueHolder.
	layouts := Dictionary new.
	projectName := NewValueHolder value: 'Unnamed project'.
	dirty := false asValueHolder.
	diagrams whenChangedDo: [ self beDirty ].
	projectName whenChangedDo: [ self beDirty ]