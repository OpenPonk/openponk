Trait {
	#name : 'OPTRelationshipWithPathPointsController',
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'accessing' }
OPTRelationshipWithPathPointsController >> modelSource [
	^ self source
		ifNil: [ self model source ]
		ifNotNil: [ self source model ]
]

{ #category : 'accessing' }
OPTRelationshipWithPathPointsController >> modelTarget [
	^ self target
		ifNil: [ self model target ]
		ifNotNil: [ self target model ]
]

{ #category : 'accessing' }
OPTRelationshipWithPathPointsController >> source [

	^ self shouldBeImplemented
]

{ #category : 'accessing' }
OPTRelationshipWithPathPointsController >> target [

	^ self shouldBeImplemented
]
