public - sticking
stick: aShape nearStartOfEdge: anEdge distance: aNumber offset: anotherNumber
	| callbacks |
	callbacks := self callbacksOfEdge: anEdge.
	aShape when: TRMouseDragEnd do: [ self doFix: aShape nearStartOfEdge: anEdge callbacks: callbacks ].
	self
		doStick: aShape
		nearStartOfEdge: anEdge
		distance: aNumber
		offset: anotherNumber
		callbacks: callbacks