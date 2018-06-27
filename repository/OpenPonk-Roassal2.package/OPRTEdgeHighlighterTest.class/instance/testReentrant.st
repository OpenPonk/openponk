tests
testReentrant
	self assert: (model shape colorFor: model) equals: Color blue.
	highlighter highlight: model color: Color red.
	self assert: (model shape colorFor: model) equals: Color red.
	highlighter highlight: model color: Color yellow.
	self assert: (model shape colorFor: model) equals: Color red.
	highlighter remove.
	self assert: (model shape colorFor: model) equals: Color blue