accessing
modelIdFrom: aString
	aString size = 36
		ifTrue: [ ^ UUID fromString: aString ].
	(NumberParser isNumber: aString)
		ifTrue: [ ^ aString asNumber ].
	^ aString