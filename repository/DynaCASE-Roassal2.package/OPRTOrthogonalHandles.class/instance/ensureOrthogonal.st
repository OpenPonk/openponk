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
			[ path := edge shape pathFor: edge.
			self router
				points:
					{path first.
					(path first x @ path last y).
					path last}.
			edge update.
			edge signalUpdate ]	"self shouldBeImplemented."