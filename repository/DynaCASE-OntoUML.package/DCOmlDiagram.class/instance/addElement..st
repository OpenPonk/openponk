metamodel
addElement: anElement

	(anElement isKindOf: ElementClass) 
		ifTrue: [ 
			anElement metaModel isNil 
				ifTrue: [ anElement 
								metaModel: self metaModel 
								checkDuplicity: false];
				ifFalse: [ self metaModel 
								addElement: anElement 
								checkDuplicity: false ] ].
		
	super add: anElement