accessing
element: xElement 
	element isNil & xElement notNil
		ifTrue: [element := xElement.
			element attributes add: self];
		 
		ifFalse: [self error: 'Error to setting element of this attribute. Element was set or new element is nil.']