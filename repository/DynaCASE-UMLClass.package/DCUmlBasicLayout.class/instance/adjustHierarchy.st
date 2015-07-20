private - layout
adjustHierarchy
	| roots joint |
	roots := Dictionary new.
	self collectGeneralizationFigures do: [ :each | (roots at: each to ifAbsentPut: [ OrderedCollection new ]) add: each ].
	roots
		keysAndValuesDo: [ :parent :edges | 
			joint := parent encompassingRectangle bottomCenter + (0 @ 30).
			edges
				do: [ :each | 
					each shape removeAllPoints.
					each shape addPoint: each from encompassingRectangle topCenter x @ joint y.
					each shape addPoint: joint.
					each update.
					each signalUpdate
					"					each shape rebuildFor: each" ] ]