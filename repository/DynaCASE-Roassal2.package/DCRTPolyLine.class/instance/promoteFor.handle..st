as yet unclassified
promoteFor: anEdge handle: aMidpointHandle
	| newPoint |
	"1. Add point at midpoint's place.
	 2. Remove midpoint handle.
	 3. Do full reload."
	newPoint := DoubleLink value: aMidpointHandle element position.
	anEdge from = aMidpointHandle from
		ifTrue: [ points addFirst: newPoint ]
		ifFalse: [ points add: newPoint afterLink: (handles detect: [ :each | each element = aMidpointHandle from ]) pointLink ].
	self rebuildFor: anEdge.
	anEdge view canvas morph resetShapeBeingPointed