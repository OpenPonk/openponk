"
I am a mock representing an entity connecting two other entities.
"
Class {
	#name : #OPTestRelationModel,
	#superclass : #Model,
	#instVars : [
		'source',
		'target'
	],
	#category : 'OpenPonk-Core-Controllers - Tests'
}

{ #category : #accessing }
OPTestRelationModel >> name [
	^ 'container'
]

{ #category : #accessing }
OPTestRelationModel >> source [
	^ source
]

{ #category : #accessing }
OPTestRelationModel >> source: anObject [
	source := anObject
]

{ #category : #accessing }
OPTestRelationModel >> target [
	^ target
]

{ #category : #accessing }
OPTestRelationModel >> target: anObject [
	target := anObject
]
