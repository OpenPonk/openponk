private
highlight: aView color: aColor
	self hasStore
		ifTrue: [ ^ self ].
	model := aView.
	self store: aView canvas color.
	aView canvas color: aColor.
	aView signalUpdate