as yet unclassified
newHandleBetween: first and: second
	first position x = second position x
		ifTrue: [ ^ DCRTVerticalHandle new ].
	first position y = second position y
		ifTrue: [ ^ DCRTHorizontalHandle new ].
	self error: 'Can''t determine handle type.'