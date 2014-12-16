accessing
generalizations
	owner ifNil: [ ^ #() ].
	^ (owner elements select: [ :each | each isKindOf: Generalization ])
		select: [ :each | each child == self | (each parent == self) ]