accessing
end: xEnd
	| found | 
	[ found := xEnd searchAssociation: name]
		on: Error
		do: [end isNil & xEnd notNil
				ifTrue: [end := xEnd.
					end associations add: self.
					^ self]; 
				
				ifFalse: [self error: 'Is not allowed to change end of association.']].
	
	xEnd = start 
		ifTrue: [ end := xEnd ];
		ifFalse: [ self error: 'Association ',self name,' exist in this element.' ]