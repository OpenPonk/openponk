removing
removeElement: aRTElement
	self removeElement: aRTElement edge: ((self edgeOf: aRTElement) ifNil: [ ^ nil ])