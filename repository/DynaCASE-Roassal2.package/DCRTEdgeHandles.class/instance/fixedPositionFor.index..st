adding
fixedPositionFor: aPoint index: anIndex
	^ aPoint nearestPointOnLineFrom: (bendPoints at: anIndex) to: (bendPoints at: anIndex + 1)