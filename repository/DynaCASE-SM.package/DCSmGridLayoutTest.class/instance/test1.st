as yet unclassified
test1
	| diagram layouter layoutModel layout |
	diagram := self createDiagram1.
	layouter := DCSmGridLayoutGenerator new
		model: diagram;
		width: 2;
		cellSize: 100 @ 50.
	layoutModel := layouter generateLayout.
	layout := layoutModel layout.
	self assert: layout size = 8.
	self assert: (layout at: 1) layout boundingBox = (0 @ 0 corner: 100 @ 50).
	self assert: (layout at: 2) layout boundingBox = (100 @ 0 corner: 200 @ 50).
	self assert: (layout at: 3) layout boundingBox = (0 @ 50 corner: 100 @ 100).
	self assert: (layout at: 4) layout boundingBox = (100 @ 50 corner: 200 @ 100)	"
		its a Bag...
	self assert: ((layout at: 5) layout points at: 1) = (150 @ 25).
	self assert: ((layout at: 5) layout points at: 2) = (50 @ 75).
	self assert: ((layout at: 6) layout points at: 1) = (50 @ 25).
	self assert: ((layout at: 6) layout points at: 2) = (50 @ 75).
	self assert: ((layout at: 7) layout points at: 1) = (150 @ 25).
	self assert: ((layout at: 7) layout points at: 2) = (150 @ 75).
	self assert: ((layout at: 8) layout points at: 1) = (50 @ 75).
	self assert: ((layout at: 8) layout points at: 2) = (150 @ 25)
	"