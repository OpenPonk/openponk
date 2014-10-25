public - sticking
stick: aShape alongEdge: anEdge balance: aFloat offset: aNumber
	| callbacks |
	callbacks := self callbacksOfEdge: anEdge.
	aShape when: TRMouseDragEnd do: [ self doFix: aShape alongEdge: anEdge callbacks: callbacks ].
	self
		doStick: aShape
		alongEdge: anEdge
		balance: aFloat
		offset: aNumber
		callbacks: callbacks