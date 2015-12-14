geometry
edgesFor: aVertex
	^ self edges select: [ :each | each from = aVertex | (each to = aVertex) ]