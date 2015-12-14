accessing
outgoing
	^ self edges select: [ :each | each from = self ]