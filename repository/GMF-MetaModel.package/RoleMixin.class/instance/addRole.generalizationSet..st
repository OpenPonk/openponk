adding
addRole: aRole generalizationSet: aGeneralizationSet
	(aRole isMemberOf: Role) 
		ifTrue: [roles add: aRole.
			aGeneralizationSet complete: true.
			aGeneralizationSet disjoint: true.
			Generalization parent: self child: aRole generalizationSet: aGeneralizationSet];
		
		ifFalse: [self error: 'We can add only roles to collection.']