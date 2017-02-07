hooks
initializeElement: anElement
	self
		assert: [ anElement class ~~ RTView ]
		description: 'Please use RTDraggableView instead'.
	anElement
		when: TRMouseDragging
		do:
			[ :e | 
			| d t |
			t := RTGroup withAll: groupToDrag.
			(t includes: anElement)
				ifFalse: [ t add: anElement ].
			anElement view
				ifNotNil:
					[ d := anElement view canvas camera distanceFromPixelToSpace: e step.
					t translateBy: (self transformDistance: d forElement: anElement).
					self constraintIfNecessary: anElement.
					e signalUpdate ] ]