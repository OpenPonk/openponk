public
trachelShapeFor: anEdge
	| multiShape path |
	multiShape := super trachelShapeFor: anEdge.
	path := self pathFor: anEdge.
	multiShape
		addShape: (decorations head trachelShapeFor: anEdge from: path allButLast last);
		addShape: (decorations tail trachelShapeFor: anEdge from: path second).
	^ multiShape