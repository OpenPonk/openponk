accessing
applyRTBasedLayout: aLayout
	| figures elements edges |
	figures := self controllers collect: [ :each | each figure ].
	elements := figures select: [ :each | each isKindOf: RTElement ].
	edges := figures select: [ :each | each isKindOf: RTEdge ].
	aLayout on: elements edges: edges.
	self updateView