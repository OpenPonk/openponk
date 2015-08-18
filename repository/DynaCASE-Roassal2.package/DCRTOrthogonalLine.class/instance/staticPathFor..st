rendering
staticPathFor: anEdge
	| path |
	path := points asOrderedCollection.
	path addFirst: anEdge from position.
	path addLast: anEdge to position.
	path at: 1 put: (anEdge from encompassingRectangle pointNearestTo: path second).
	path atLast: 1 put: (anEdge to encompassingRectangle pointNearestTo: (path atLast: 2)).
	^ path