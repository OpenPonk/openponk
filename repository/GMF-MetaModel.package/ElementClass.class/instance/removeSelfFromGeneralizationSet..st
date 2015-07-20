inheritance
removeSelfFromGeneralizationSet: aGeneralizationSet
	| removed |
	self assert: (self generalizationSets includes: aGeneralizationSet).
	removed := OrderedCollection new.
	removed addAll: (aGeneralizationSet remove: self name).
	^ removed