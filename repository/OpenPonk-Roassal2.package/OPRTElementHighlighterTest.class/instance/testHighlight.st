running
testHighlight
	| overlay |
	highlighter highlight: model color: Color red.
	overlay := model attributes at: highlighter attributeKey.
	self assert: (overlay shape colorFor: model) equals: (Color red alpha: 0.2).
	self assert: overlay view equals: view.
	highlighter remove.
	self assert: overlay view equals: nil