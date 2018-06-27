private
highlight: anEdge color: aColor
	self hasStore
		ifTrue: [ ^ self ].
	model := anEdge.
	self store: (model shape colorFor: model).
	model shape color: aColor.
	model update.
	model view signalUpdate