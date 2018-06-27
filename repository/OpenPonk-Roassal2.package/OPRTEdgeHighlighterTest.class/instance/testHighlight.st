tests
testHighlight
	self assert: (model shape colorFor: model) equals: Color blue.
	highlighter highlight: model color: Color red.
	self assert: (model shape colorFor: model) equals: Color red.
	highlighter remove.
	self assert: (model shape colorFor: model) equals: Color blue