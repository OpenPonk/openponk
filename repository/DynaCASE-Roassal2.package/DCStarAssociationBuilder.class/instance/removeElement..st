removing
removeElement: aRTElement
	"removes aRTElement from list of star association elements and its edge from canvas"

	self removeElement: aRTElement edge: ((self edgeOf: aRTElement) ifNil: [ ^ nil ])