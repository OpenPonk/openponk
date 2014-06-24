testing
is: aParentVertex ancestorOf: aChildVertex
	aParentVertex = aChildVertex
		ifTrue: [ ^ true ]
		ifFalse: [ 
			aChildVertex container stateMachine notEmpty
				ifTrue: [ ^ true ]
				ifFalse: [ 
					aParentVertex container stateMachine notEmpty
						ifTrue: [ ^ false ]
						ifFalse: [ self is: aParentVertex container state ancestorOf: aChildVertex ] ] ]