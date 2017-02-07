as yet unclassified
promoteFor: anEdge handle: aMidpointHandle
	| newPoint |
	"1. Add point at midpoint's place.
	 2. Remove midpoint handle.
	 3. Do full reload."
	newPoint := DoubleLink value: aMidpointHandle element position.
	anEdge from = aMidpointHandle from
		ifTrue: [ self router pointLinks addFirst: newPoint ]
		ifFalse: [ self router pointLinks add: newPoint afterLink: (handles detect: [ :each | each element = aMidpointHandle from ]) pointLink ].
	self rebuild.
	anEdge view canvas morph resetShapeBeingPointed