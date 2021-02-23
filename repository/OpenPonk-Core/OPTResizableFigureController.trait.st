Trait {
	#name : #OPTResizableFigureController,
	#category : #'OpenPonk-Core-Controllers'
}

{ #category : #accessing }
OPTResizableFigureController >> layout [
	^ OPElementLayout
		withPosition: self figure position
		extent: self figure extent
]

{ #category : #accessing }
OPTResizableFigureController >> layout: anElementLayout [
	super layout: anElementLayout.
	anElementLayout hasExtent
		ifTrue: [ self figure extent: anElementLayout extent ]
]
