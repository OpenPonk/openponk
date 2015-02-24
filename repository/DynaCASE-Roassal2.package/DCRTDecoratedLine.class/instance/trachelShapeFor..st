public
trachelShapeFor: anEdge
	^ TRCompositeShape new
		addShape: (line trachelShapeFor: anEdge);
		addShape: (head trachelShapeFor: anEdge);
		addShape: (tail trachelShapeFor: anEdge);
		yourself