actions
attachTo: anElement
	target = anElement
		ifFalse: [ 
			self running
				ifTrue: [ self cancel ].
			target := anElement.
			self attachToTarget ]