running
testHighlight
	model canvas color: Color blue.
	self assert: model canvas color equals: Color blue.
	highlighter highlight: model color: Color red.
	self assert: model canvas color equals: Color red.
	highlighter remove.
	self assert: model canvas color equals: Color blue