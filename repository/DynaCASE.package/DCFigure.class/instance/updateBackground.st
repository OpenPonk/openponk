rendering
updateBackground
	self hasFigures
		ifTrue: [ 
			background view ifNil: [ view add: background ].
			self resizeBackground ]
		ifFalse: [ background view ifNotNil: [ background remove ] ]