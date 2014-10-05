accessing
associations
	owner ifNil: [ ^ #() ].
	^ (owner elements select: [ :each | each class = DCUmliteAssociation ])
		select: [ :each | each target = self | (each source = self) ]