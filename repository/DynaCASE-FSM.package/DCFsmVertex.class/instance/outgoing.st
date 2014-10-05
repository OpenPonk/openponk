accessing
outgoing
	owner ifNil: [ ^ #() ].
	^ (owner elements select: [ :each | each class = DCFsmTransition ]) select: [ :each | each source = self ]