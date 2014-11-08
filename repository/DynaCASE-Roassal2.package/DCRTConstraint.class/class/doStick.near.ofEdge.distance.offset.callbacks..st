private 
doStick: aShape near: startOrEnd ofEdge: anEdge distance: aNumber offset: anotherNumber callbacks: callbacks
	| block |
	block := [ :shape | 
	self
		perform: ('move:near' , startOrEnd asString capitalized , 'OfEdge:distance:offset:') asSymbol
		withArguments:
			(Array
				with: aShape
				with: anEdge
				with: aNumber
				with: anotherNumber) ].
	block value: aShape.
	callbacks do: [ :each | each block: block ]