running
testReentrant
	| overlay |
	highlighter highlight: model color: Color red.
	overlay := model load.
	self assert: (overlay shape colorFor: model) equals: (Color red alpha: 0.2).
	highlighter highlight: model color: Color yellow.
	self assert: model load equals: overlay.
	self assert: (overlay shape colorFor: model) equals: (Color red alpha: 0.2).
	highlighter remove.
	self assert: overlay view equals: nil