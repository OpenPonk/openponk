positioning
basicMoveBy: aVector
	positionLink value: positionLink value + aVector.
	element
		ifNotNil:
			[ element trachelShape doWithoutCallbacks: [ element translateBy: aVector ] ]