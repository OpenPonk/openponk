accessing
incoming
	owner ifNil: [ ^ #() ].
	^ (owner elements select: [ :each | each class = DCFsmTransition ]) select: [ :each | each target = self ]