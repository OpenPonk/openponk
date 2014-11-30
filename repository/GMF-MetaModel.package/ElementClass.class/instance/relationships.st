as yet unclassified
relationships
	owner ifNil: [ ^ #() ].
	^ (owner elements select: [ :each | each isKindOf: ElementAssociation ])
		select: [ :each | each start == self | (each end == self) ]