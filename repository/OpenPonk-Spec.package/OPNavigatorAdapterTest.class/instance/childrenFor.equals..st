asserting
childrenFor: anObject equals: aCollection
	^ self assertCollection: (adapter childrenFor: anObject) hasSameElements: aCollection