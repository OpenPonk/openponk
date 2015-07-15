removing
removeRelationship: aRelationship
	(aRelationship isKindOf: ElementAssociation)
		ifTrue: [ self removeAssociation: aRelationship ].
	(aRelationship isKindOf: Generalization)
		ifTrue: [ self removeGeneralization: aRelationship ].
	^ OrderedCollection with: aRelationship