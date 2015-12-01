rendering
changeDecorationsFor: anEdge trachelShape: trachelShape
	| path oldTail oldHead |
	path := self pathFor: anEdge.
	oldTail := trachelShape shapes last.
	oldTail class = decorations tail trachelShapeClass
		ifFalse:
			[ 
			| newTail |
			newTail := decorations tail trachelShapeFor: anEdge from: path second.
			trachelShape removeLast remove.
			trachelShape addShape: newTail.
			newTail element: trachelShape element.
			newTail announcer: trachelShape element announcer.
			newTail addedIn: trachelShape canvas ].

	oldHead := trachelShape shapes atLast: 2.
	oldHead class = decorations head trachelShapeClass
		ifFalse:
			[ 
			| newHead |
			newHead := decorations head trachelShapeFor: anEdge from: (path atLast: 2).
			(trachelShape removeAt: trachelShape shapes size - 1) remove.
			trachelShape addShape: newHead beforeIndex: trachelShape shapes size.
			newHead element: trachelShape element.
			newHead announcer: trachelShape element announcer.
			newHead addedIn: trachelShape canvas ]