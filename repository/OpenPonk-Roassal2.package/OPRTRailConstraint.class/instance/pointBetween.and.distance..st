as yet unclassified
pointBetween: a and: b distance: dist
	| denom |
	denom := a dist: b.
	^ denom > 0
		ifTrue: [ a + ((b - a) / denom * dist) ]
		ifFalse: [ a ]
	"
	^ a + ((b - a) / (a dist: b) * dist)"