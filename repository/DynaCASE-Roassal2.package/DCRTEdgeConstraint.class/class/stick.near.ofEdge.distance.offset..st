public - sticking
stick: aShape near: origin ofEdge: anEdge distance: aNumber offset: anotherNumber
	"possible origins: #start , #end"

	| moveBlock |
	moveBlock := [ 
	self
		perform: ('move:near' , origin asString capitalized , 'OfEdge:distance:offset:') asSymbol
		withArguments:
			(Array
				with: aShape
				with: anEdge
				with: aNumber
				with: anotherNumber) ].
	moveBlock value.
	self
		subscribeShape: aShape
		edge: anEdge
		whenDragOnce: [ self fix: aShape near: origin ofEdge: anEdge ]
		whenMove: moveBlock