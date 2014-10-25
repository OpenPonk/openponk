private 
doStick: aShape nearEndOfEdge: anEdge distance: aNumber offset: anotherNumber callbacks: callbacks
	| block |
	block := [ :shape | 
	self
		move: aShape
		nearEndOfEdge: anEdge
		distance: aNumber
		offset: anotherNumber ].
	block value: aShape.
	callbacks do: [ :each | each block: block ]