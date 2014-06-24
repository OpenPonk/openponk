as yet unclassified
isContainedInRegion: aRegion
	container = aRegion
		ifTrue: [ ^ true ]
		ifFalse: [ 
			aRegion isEmpty
				ifTrue: [ ^ false ]
				ifFalse: [ container state isContainedInRegion: aRegion ] ]