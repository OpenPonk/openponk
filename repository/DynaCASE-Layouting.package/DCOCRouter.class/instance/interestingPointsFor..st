as yet unclassified
interestingPointsFor: elements
	^ elements collect: [ :each | each -> (self interestingPointFor: each) ]