as yet unclassified
computePosition
	position > 1
		ifTrue: [ ^ self connectionLength min: position ].
	position < 0
		ifTrue: [ ^ 0 max: self connectionLength - position ].
	^ self connectionLength * position