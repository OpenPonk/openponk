rendering
pathFor: anEdge
	^ handleList ifNil: [ self staticPathFor: anEdge ] ifNotNil: [ handleList asArray collect: #position ]