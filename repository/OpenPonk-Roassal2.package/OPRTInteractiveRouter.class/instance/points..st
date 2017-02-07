accessing
points: aCollection
	points removeAll.
	aCollection do: [ :each | self addPoint: each ]