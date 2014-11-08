public - sticking
fix: aShape near: startOrEnd ofEdge: anEdge
	| callbacks block |
	callbacks := self createCallbacksOfEdge: anEdge.
	block := [ 
	self
		doFix: aShape
		near: startOrEnd
		ofEdge: anEdge
		callbacks: callbacks ].
	aShape when: TRMouseDragEnd do: block.
	block value