public
trachelShapeFor: anEdge
	| compositeShape |
	compositeShape := TRCompositeShape new.
	compositeShape addShape: (line trachelShapeFor: anEdge).
	head ifNotNil: [ compositeShape addShape: (head trachelShapeFor: anEdge) ].
	tail ifNotNil: [ compositeShape addShape: (tail trachelShapeFor: anEdge) ].
	^ compositeShape