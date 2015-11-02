as yet unclassified
allEdgeMarks
	^ (self edges collect: [ :each | each -> (self edgeMarksFor: each) ]) as: OrderedDictionary