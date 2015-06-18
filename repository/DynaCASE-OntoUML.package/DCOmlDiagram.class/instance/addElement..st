metamodel
addElement: anElement

	(anElement isKindOf: ElementClass) 
		ifTrue: [ self metaModel addElement: anElement ].
		
	super add: anElement