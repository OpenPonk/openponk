running
testReentrant
	| overlay |
	highlighter highlight: model color: Color red.
	overlay := highlighter load.
	self assert: (overlay shape colorFor: model) equals: (Color red alpha: 0.2).
	highlighter highlight: model color: Color yellow.
	self assert: highlighter load equals: overlay.
	self assert: (overlay shape colorFor: model) equals: (Color red alpha: 0.2).
	highlighter remove.
	self assert: overlay view equals: nil