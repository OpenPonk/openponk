Trait {
	#name : #OPTRelationshipWithPathPointsController,
	#category : #'OpenPonk-Core-Controllers'
}

{ #category : #accessing }
OPTRelationshipWithPathPointsController >> modelSource [
	^ self source
		ifNil: [ self model source ]
		ifNotNil: [ self source model ]
]

{ #category : #accessing }
OPTRelationshipWithPathPointsController >> modelTarget [
	^ self target
		ifNil: [ self model target ]
		ifNotNil: [ self target model ]
]

{ #category : #accessing }
OPTRelationshipWithPathPointsController >> source [

	^ self explicitRequirement
]

{ #category : #accessing }
OPTRelationshipWithPathPointsController >> target [

	^ self explicitRequirement
]
