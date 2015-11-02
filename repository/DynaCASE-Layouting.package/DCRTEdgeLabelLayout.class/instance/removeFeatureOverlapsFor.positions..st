as yet unclassified
removeFeatureOverlapsFor: aLabel positions: aCollection
	"Remove all positions overlapping another edge or element, but not label."

	| extent rectangles otherLines e segment |
	extent := aLabel extent.
	rectangles := aCollection.
	"Remove positions overlapping any elements"
	rectangles := rectangles
		reject:
			[ :rect | 
			self elements
				detect: [ :el | el encompassingRectangle intersects: rect ]
				ifFound: [ true ]
				ifNone: [ false ] ].
	"Remove positions overlapping other edges"
	otherLines := self edges
		reject: [ :edge | edge = (self edgeForLabel: aLabel) ]
		thenCollect:
			[ :edge | RTLineSegment from: (edge shape startingPointOf: edge) to: (edge shape endingPointOf: edge) ].
	rectangles := rectangles
		reject:
			[ :rect | 
			otherLines
				detect: [ :line | (line intersectRectangle: rect) isNotEmpty ]
				ifFound: [ true ]
				ifNone: [ false ] ].
	"Remove positions overlapping it's own line"
	e := self edgeForLabel: aLabel.
	segment := RTLineSegment from: (e shape startingPointOf: e) to: (e shape endingPointOf: e).
	rectangles := rectangles
		reject: [ :rect | ((segment intersectRectangle: rect) collect: #rounded) isNotEmpty ].
	^ rectangles