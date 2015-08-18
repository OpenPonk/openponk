private
addHandlesFor: aPath
	self addAnchorSegmentFrom: aPath first to: aPath last.
	aPath allButFirst allButLast do: [ :each | self addCornerFor: each ].
	handleFactory addSegmentHandlesTo: handles