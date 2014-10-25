private 
doStick: aShape nearStartOfEdge: anEdge distance: aNumber offset: anotherNumber callbacks: callbacks
	| block |
	block := [ :shape | 
	self
		move: aShape
		nearStartOfEdge: anEdge
		distance: aNumber
		offset: anotherNumber ].
	block value: aShape.
	callbacks do: [ :each | each block: block ]