propagation
neighbor: aHandle hasMovedBy: aVector
	| target |
	target := self position + aVector.
	aHandle isVertical
		ifTrue: [ self horizontalMovedTo: aHandle x @ target y ]
		ifFalse: [ self verticalMovedTo: target x @ aHandle y ]