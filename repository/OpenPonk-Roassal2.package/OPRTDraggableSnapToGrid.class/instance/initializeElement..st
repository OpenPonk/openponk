hooks
initializeElement: element
	element when: TRMouseDragStart do: [ :event | totalDistance := 0 @ 0 ].
	element
		when: TRMouseDragging
		do: [ :e | 
			| d t |
			t := RTGroup withAll: (self groupToDragFor: element view).
			(t includes: element)
				ifFalse: [ t add: element ].
			d := element view canvas camera distanceFromPixelToSpace: e step.
			t translateBy: (self transformDistance: d forElement: element).
			self constraintIfNecessary: element.
			e signalUpdate ]