"
Trait used by controllers of relationships rendered as paths with routing points.
Provides access to source and target models and their corresponding diagram elements.
"
Trait {
	#name : 'OPTRelationshipWithPathPointsController',
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'accessing' }
OPTRelationshipWithPathPointsController >> modelSource [

	^ self viewModel modelSource
]

{ #category : 'accessing' }
OPTRelationshipWithPathPointsController >> modelTarget [

	^ self viewModel modelTarget
]

{ #category : 'accessing' }
OPTRelationshipWithPathPointsController >> source [

	^ self shouldBeImplemented
]

{ #category : 'accessing' }
OPTRelationshipWithPathPointsController >> target [

	^ self shouldBeImplemented
]
