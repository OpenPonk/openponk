as yet unclassified
removeFeatureOverlaps: aDictionary
	"Remove all positions overlapping another edge or element, but not label."

	| newMap |
	newMap := OrderedDictionary new.
	aDictionary
		keysAndValuesDo:
			[ :label :positions | newMap at: label put: (self removeFeatureOverlapsFor: label positions: positions) ].
	^ newMap