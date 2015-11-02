as yet unclassified
addBoundingBoxFor: aCollection
	aCollection do: [ :each | self addBoundingBoxTo: each ]