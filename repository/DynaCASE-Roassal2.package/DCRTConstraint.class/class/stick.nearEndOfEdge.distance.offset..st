public - sticking
stick: aShape nearEndOfEdge: anEdge distance: aNumber offset: anotherNumber
	| callbacks |
	callbacks := self callbacksOfEdge: anEdge.
	aShape when: TRMouseDragEnd do: [ self doFix: aShape nearEndOfEdge: anEdge callbacks: callbacks ].
	self
		doStick: aShape
		nearEndOfEdge: anEdge
		distance: aNumber
		offset: anotherNumber
		callbacks: callbacks