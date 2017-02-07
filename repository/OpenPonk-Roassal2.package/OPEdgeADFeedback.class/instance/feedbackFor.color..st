private
feedbackFor: anEdge color: aColor
	feedback := anEdge.
	(anEdge attributes includesKey: self originalColorSymbol)
		ifTrue: [ ^ self ].
	anEdge attributes at: self originalColorSymbol put: anEdge shape color.
	anEdge shape color: aColor.
	anEdge update.
	anEdge view signalUpdate