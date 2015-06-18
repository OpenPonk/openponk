accessing
isFinal: aBoolean
	aBoolean
		ifTrue: [ self addInnerCircle ]
		ifFalse: [ self removeInnerCircle ]