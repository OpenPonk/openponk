adding
addRole: aRole 
	(aRole isMemberOf: Role) 
		ifTrue: [roles add: aRole.
			ParentClass parentClass: self child: aRole];
		
		ifFalse: [self error: 'We can add only roles to collection.']