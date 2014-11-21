as yet unclassified
trachelShapeFor: anEdge
	^ tail
		ifFalse: [ self trachelShapeAsHeadFor: anEdge ]
		ifTrue: [ self trachelShapeAsTailFor: anEdge ]