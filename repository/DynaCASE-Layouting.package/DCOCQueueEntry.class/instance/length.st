accessing
length
	parent ifNil: [ ^ 0 ].
	^ self parent length + (self node distanceTo: self parent node)