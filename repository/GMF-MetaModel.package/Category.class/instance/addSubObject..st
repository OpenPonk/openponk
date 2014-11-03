adding
addSubObject: anObject 
	(anObject isKindOf: SortalClass)
		ifTrue: [subObjects add: anObject.
			ParentClass parentClass: self complete: false disjoint: true child: anObject]; 
		
		ifFalse: [self error: 'We can add only Sortal Class to collection.']