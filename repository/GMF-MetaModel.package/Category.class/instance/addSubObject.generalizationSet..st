adding
addSubObject: anObject generalizationSet: aGeneralizationSet
	(anObject isKindOf: SortalClass)
		ifTrue: [subObjects add: anObject.
			aGeneralizationSet complete: false.
			aGeneralizationSet disjoint: true.
			Generalization parent: self child: anObject generalizationSet: aGeneralizationSet]; 
		
		ifFalse: [self error: 'We can add only Sortal Class to collection.']