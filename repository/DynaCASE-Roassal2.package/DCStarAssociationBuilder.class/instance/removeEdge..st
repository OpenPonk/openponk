removing
removeEdge: aRTEdge
	aRTEdge from = center
		ifTrue: [ self removeElement: aRTEdge to edge: aRTEdge ].
	aRTEdge to = center
		ifTrue: [ self removeElement: aRTEdge from edge: aRTEdge ]