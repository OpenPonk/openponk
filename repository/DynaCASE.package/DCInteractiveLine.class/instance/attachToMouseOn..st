actions
attachToMouseOn: position
	target = mouseBox
		ifTrue: [ 
			mouseBox
				translateTo: position - (diagramController view canvas extent / 2) + diagramController view canvas camera position.
			diagramController updateView ]
		ifFalse: [ 
			self running
				ifTrue: [ self cancel ].
			target := mouseBox.
			self attachToTarget ]