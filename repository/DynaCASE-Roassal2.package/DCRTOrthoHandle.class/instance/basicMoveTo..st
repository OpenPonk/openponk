positioning
basicMoveTo: aPosition
	element trachelShape doWithoutCallbacks: [ element translateTo: aPosition ].
	positionLink value: element position