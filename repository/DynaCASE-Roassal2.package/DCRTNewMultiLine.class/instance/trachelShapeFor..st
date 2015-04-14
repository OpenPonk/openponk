public
trachelShapeFor: anEdge
	| multiShape path |
	multiShape := super trachelShapeFor: anEdge.
	path := self pathFor: anEdge.
	multiShape
		addShape: (head trachelShapeFor: anEdge from: path allButLast last);
		addShape: (tail trachelShapeFor: anEdge from: path second).
	^ multiShape