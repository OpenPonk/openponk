positioning
basicMoveTo: aPosition
	positionLink value: aPosition.
	element
		ifNotNil:
			[ element trachelShape
				doWithoutCallbacks: [ element translateTo: aPosition ] ]