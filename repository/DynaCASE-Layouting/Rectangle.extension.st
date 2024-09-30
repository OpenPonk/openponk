Extension { #name : 'Rectangle' }

{ #category : '*DynaCASE-Layouting' }
Rectangle >> nearestDistanceTo: anotherRectangle [
	| line this that |
	line := RTLineSegment from: self center to: anotherRectangle center.
	this := (line intersectRectangle: self) anyOne.
	that := (line intersectRectangle: anotherRectangle) anyOne.
	^ this dist: that
]

{ #category : '*DynaCASE-Layouting' }
Rectangle >> nearestDistanceToLineFrom: p1 to: p2 [
	"Note this will give points beyond the endpoints."

	^ (self corners collect: [ :point | point dist: (point nearestPointOnLineFrom: p1 to: p2) ])
		min
]

{ #category : '*DynaCASE-Layouting' }
Rectangle >> nearestPointAlongLineFrom: p1 to: p2 [
	"Note this will give points beyond the endpoints."

	^ (self corners collect: [ :point | point nearestPointAlongLineFrom: p1 to: p2 ]) min
]

{ #category : '*DynaCASE-Layouting' }
Rectangle >> nearestPointOnLineFrom: p1 to: p2 [
	"This will not give points beyond the endpoints"

	^ (self nearestPointAlongLineFrom: p1 to: p2) adhereTo: (p1 rectangle: p2)
]
