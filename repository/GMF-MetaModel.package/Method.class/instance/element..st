accessing
element: xElement 
	element isNil & xElement notNil
		ifTrue: [element := xElement.
			element methods add: self]; 
		
		ifFalse: [self error: 'Error to setting element of this method. Element was set or new element is nil.']