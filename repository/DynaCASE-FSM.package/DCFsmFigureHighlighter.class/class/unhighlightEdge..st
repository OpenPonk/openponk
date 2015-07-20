api - unhighlight
unhighlightEdge: anEdge
	(anEdge hasAttribute: self name)
		ifFalse: [ ^ self ].
	anEdge shape color: (anEdge attributeAt: self name).
	anEdge removeAttributeAt: self name.
	anEdge update.
	anEdge signalUpdate