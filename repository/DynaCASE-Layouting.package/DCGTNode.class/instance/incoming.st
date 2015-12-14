accessing
incoming
	^ self edges select: [ :each | each to = self ]