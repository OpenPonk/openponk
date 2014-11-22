public
trachelShapeFor: anEdge
	^ tail
		ifFalse: [ self trachelShapeAsHeadFor: anEdge ]
		ifTrue: [ self trachelShapeAsTailFor: anEdge ]