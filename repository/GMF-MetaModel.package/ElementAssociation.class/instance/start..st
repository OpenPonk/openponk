accessing
start: xStart 
	[xStart searchAssociation: name]
		on: Error
		do: [ start isNil & xStart notNil
		ifTrue: [start := xStart.
			start associations add: self.
			^ self];
		
		ifFalse: [self error: 'Is not allowed to change start of association.'] ].
	xStart = end 
		ifTrue: [ start := xStart ];
		ifFalse: [ self error: 'Association ',self name,' exist in this element.' ]