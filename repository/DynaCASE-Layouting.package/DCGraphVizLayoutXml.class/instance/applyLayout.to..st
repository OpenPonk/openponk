hook
applyLayout: aCollection to: els
	aCollection
		collect: [ :each | (els at: (self nodeIndexFor: each)) translateTo: (self nodePositionFor: each) ]