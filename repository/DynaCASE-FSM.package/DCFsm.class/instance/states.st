accessing
states
	^ elements select: [ :each | each isKindOf: DCFsmVertex ]