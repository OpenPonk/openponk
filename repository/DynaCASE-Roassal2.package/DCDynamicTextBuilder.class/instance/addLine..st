adding
addLine: aTextOrValueHolder
	| label lineTextHolder element |
	(aTextOrValueHolder isKindOf: NewValueHolder)
		ifTrue: [ lineTextHolder := aTextOrValueHolder ]
		ifFalse: [ lineTextHolder := NewValueHolder value: aTextOrValueHolder ].
	textHolders add: lineTextHolder.
	element := RTElement new.
	label := RTLabel new text: lineTextHolder value.
	element + label.
	elements add: element.
	lineTextHolder
		whenChangedDo: [ :newValue | 
			label text: newValue.
			element update.
			parent ifNil: [ self update ] ifNotNil: [ parent update ] ].
	view ifNotNil: [ self elementAdded: element ]