tests
testRemove
	self deny: highlighter hasStore.
	highlighter highlight: model color: Color red.
	self assert: highlighter hasStore.
	highlighter remove.
	self deny: highlighter hasStore