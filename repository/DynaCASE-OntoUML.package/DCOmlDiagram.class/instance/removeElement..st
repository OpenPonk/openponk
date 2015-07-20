metamodel
removeElement: anElement
	| forRemove |
	(anElement isKindOf: ElementClass)
		ifTrue: [ forRemove := self metaModel removeElement: anElement ].
	(anElement isKindOf: Relationship)
		ifTrue: [ forRemove := self metaModel removeRelationship: anElement ].

	self assert: (forRemove allSatisfy: [ :each | super has: each ]).
	forRemove
		do: [ :each | 
			(self has: each)
				ifTrue: [ super remove: each ] ]