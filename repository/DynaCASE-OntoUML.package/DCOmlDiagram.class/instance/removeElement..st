metamodel
removeElement: anElement
	| forRemove |
	
	(anElement isKindOf: ElementClass) 
		ifTrue: [ forRemove := self metaModel removeElement: anElement ].
	(anElement isKindOf: Relationship)
		ifTrue: [ forRemove := self metaModel removeRelationship: anElement ].
	
	(forRemove isMemberOf: OrderedCollection)
		ifTrue: [ forRemove do: [ :each | super remove: each ] ];
		ifFalse: [ super remove: forRemove ]
	