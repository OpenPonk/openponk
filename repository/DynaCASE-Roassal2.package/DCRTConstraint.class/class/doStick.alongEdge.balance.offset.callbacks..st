private 
doStick: aShape alongEdge: anEdge balance: aFloat offset: aNumber callbacks: callbacks
	| block |
	block := [ :shape | 
	self
		move: aShape
		alongEdge: anEdge
		balance: aFloat
		offset: aNumber ].
	block value: aShape.
	callbacks do: [ :each | each block: block ]