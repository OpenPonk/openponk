as yet unclassified
add: newContent to: aPoint

	content addFirst: (DCGEntity new presentedAs: newContent on: aPoint).
	self changed.