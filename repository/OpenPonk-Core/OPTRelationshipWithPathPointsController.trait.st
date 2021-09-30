Trait {
	#name : #OPTRelationshipWithPathPointsController,
	#category : #'OpenPonk-Core-Controllers'
}

{ #category : #accessing }
OPTRelationshipWithPathPointsController >> layout [
	self figure shape ifNil: [ ^ OPElementLayout none ].
	(self figure shape isKindOf: OPRTConnection)
		ifFalse: [ ^ OPElementLayout none ].
	^ (self figure shape pathFor: self figure)
		ifNil: [ OPElementLayout none ]
		ifNotNil: [ :pathPoints | 
			OPElementLayout
				withPathFromSource: self pathSourceModel uuid
				throughPoints: pathPoints ]
]

{ #category : #accessing }
OPTRelationshipWithPathPointsController >> layout: aLayout [

	| router innerPoints pathPoints path |
	aLayout ifNil: [ ^ self ].
	path := aLayout path.
	path ifNil: [ ^ self ].
	pathPoints := path points.
	pathPoints ifNil: [ ^ self ].
	self figure shape ifNil: [ ^ self ].
	router := self figure shape router.
	router removeAll.
	innerPoints := pathPoints size < 2
		               ifTrue: [ pathPoints ]
		               ifFalse: [ 
		               pathPoints copyFrom: 2 to: pathPoints size - 1 ].
	self pathSourceModel uuid = path source ifFalse: [ 
		innerPoints := innerPoints reversed ].
	innerPoints do: [ :each | router addPoint: each ]
]

{ #category : #accessing }
OPTRelationshipWithPathPointsController >> pathSourceModel [
	^ self source
		ifNil: [ self model source ]
		ifNotNil: [ self source model ]
]
