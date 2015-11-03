as yet unclassified
applyAssignment: aDictionary
	aDictionary
		keysAndValuesDo:
			[ :feature :position | (self labelForEdge: feature model) translateTo: position center ]