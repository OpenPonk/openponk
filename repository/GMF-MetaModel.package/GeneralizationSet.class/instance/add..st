add/remove
add: aGeneralization
	self generalizations add: aGeneralization.
	aGeneralization child addGeneralizationSet: self
	