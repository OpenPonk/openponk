geometry
translateAllBy: aDistance
	points linksDo: [ :each | each value: each value + aDistance ].
	self rebuildHandler