computing
priorityFrom: aSource to: aDestination
	false
		ifTrue:
			[ ^ self length + (self node distanceTo: aSource) + (self node distanceTo: aDestination)
				+ (self estimateTo: aDestination) ]
		ifFalse: [ ^ self node distanceTo: aDestination ]