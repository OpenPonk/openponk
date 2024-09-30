"
I am a mock representing an entity connecting two other entities.
"
Class {
	#name : 'OPTestRelationModel',
	#superclass : 'OPTestAbstractModel',
	#instVars : [
		'source',
		'target'
	],
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'accessing' }
OPTestRelationModel >> source [
	^ source
]

{ #category : 'accessing' }
OPTestRelationModel >> source: anObject [
	source := anObject
]

{ #category : 'accessing' }
OPTestRelationModel >> target [
	^ target
]

{ #category : 'accessing' }
OPTestRelationModel >> target: anObject [
	target := anObject
]
