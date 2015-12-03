positioning
basicMoveBy: aVector
	element trachelShape doWithoutCallbacks: [ element translateBy: aVector ].
	positionLink value: element position