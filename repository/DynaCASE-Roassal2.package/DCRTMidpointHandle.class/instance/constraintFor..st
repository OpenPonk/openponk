as yet unclassified
constraintFor: anElement
	nearStart & nearEnd
		ifTrue: [ ^ self constraintForStartEnd: anElement ].
	nearStart
		ifTrue: [ ^ self constraintForStart: anElement ].
	nearEnd
		ifTrue: [ ^ self constraintForEnd: anElement ].
	TRConstraint stick: anElement trachelShape between: from trachelShape and: to trachelShape