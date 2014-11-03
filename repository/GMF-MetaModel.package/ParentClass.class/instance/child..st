accessing
child: xChild 
	child isNil & xChild notNil
		ifTrue: [child := xChild.
			xChild parents add: self]; 
		
		ifFalse: [self error: 'Error to setting child of this parent. New child is nil or child was set.']