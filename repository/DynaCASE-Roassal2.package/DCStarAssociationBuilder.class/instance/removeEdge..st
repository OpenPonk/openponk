removing
removeEdge: aRTEdge
	"removes aRTEdge from canvas and its element from list of star association elements"

	aRTEdge from = center
		ifTrue: [ self removeElement: aRTEdge to edge: aRTEdge ].
	aRTEdge to = center
		ifTrue: [ self removeElement: aRTEdge from edge: aRTEdge ]