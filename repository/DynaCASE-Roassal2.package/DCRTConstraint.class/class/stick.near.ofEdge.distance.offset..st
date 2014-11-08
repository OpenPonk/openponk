public - sticking
stick: aShape near: startOrEnd ofEdge: anEdge distance: aNumber offset: anotherNumber
	"example: DCRTConstraint stick: RTBox new near: #start ofEdge: RTEdge new distance: 50 offset: 5"

	| callbacks |
	callbacks := self createCallbacksOfEdge: anEdge.
	aShape
		when: TRMouseDragEnd
		do: [ 
			self
				doFix: aShape
				near: startOrEnd
				ofEdge: anEdge
				callbacks: callbacks ].
	self
		doStick: aShape
		near: startOrEnd
		ofEdge: anEdge
		distance: aNumber
		offset: anotherNumber
		callbacks: callbacks