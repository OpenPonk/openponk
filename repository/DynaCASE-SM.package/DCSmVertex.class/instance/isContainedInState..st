as yet unclassified
isContainedInState: aState
	(aState isComposite = false or: container isEmpty)
		ifTrue: [ ^ false ]
		ifFalse: [ 
			container state = aState
				ifTrue: [ ^ true ]
				ifFalse: [ container state isContainedInState: aState ] ]