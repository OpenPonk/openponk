private
ensureOrthogonal
	| path p isOrthogonal next |
	path := (edge shape pathFor: edge) allButFirst allButLast.
	p := path first.
	isOrthogonal := true.
	p x = path second x
		ifTrue: [ next := #x ]
		ifFalse: [ next := #y ].
	path allButFirst
		do:
			[ :each | 
			(p perform: next) = (each perform: next)
				ifTrue: [ p := each ]
				ifFalse: [ isOrthogonal := false ].
			next := next = #x
				ifTrue: [ #y ]
				ifFalse: [ #x ] ].
	isOrthogonal
		ifFalse:
			[ self shouldBeImplemented.
			self router points: {(edge from position x @ edge to position y)} ]