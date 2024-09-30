Trait {
	#name : 'OPTRelationshipWithPathPointsController',
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'accessing' }
OPTRelationshipWithPathPointsController >> modelSource [

	^ self model ifNotNil: [ :foundModel | foundModel source ]
]

{ #category : 'accessing' }
OPTRelationshipWithPathPointsController >> modelTarget [

	^ self model ifNotNil: [ :foundModel | foundModel target ]
]

{ #category : 'accessing' }
OPTRelationshipWithPathPointsController >> source [

	^ self shouldBeImplemented
]

{ #category : 'accessing' }
OPTRelationshipWithPathPointsController >> target [

	^ self shouldBeImplemented
]
