Trait {
	#name : #OPTRelationshipWithPathPointsController,
	#category : #'OpenPonk-Core-Controllers'
}

{ #category : #accessing }
OPTRelationshipWithPathPointsController >> layout [

	self figure ifNil: [ ^ OPElementLayout none ].
	(self figure isKindOf: RSAbstractControlPointsLine) ifFalse: [ 
		^ OPElementLayout none ].
	^ self figure controlPoints
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
	self figure ifNil: [ ^ self ].
	self pathSourceModel uuid = path source ifFalse: [ 
		pathPoints := pathPoints reversed ].
	self figure controlPoints: pathPoints
]

{ #category : #accessing }
OPTRelationshipWithPathPointsController >> pathSourceModel [
	^ self source
		ifNil: [ self model source ]
		ifNotNil: [ self source model ]
]
