inheritance
removeGeneralizationSet: aGeneralizationSet
	| removed |
	self assert: (self generalizationSets includes: aGeneralizationSet).
	removed := self removeSelfFromGeneralizationSet: aGeneralizationSet.
	generalizationSets remove: aGeneralizationSet.
	^ removed