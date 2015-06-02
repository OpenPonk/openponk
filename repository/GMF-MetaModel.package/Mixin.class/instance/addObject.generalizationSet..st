adding
addObject: anObject generalizationSet: aGeneralizationSet
	mixObjects add: anObject.
	aGeneralizationSet complete: true.
	aGeneralizationSet disjoint: true.
	Generalization parent: self child: anObject generalizationSet: aGeneralizationSet