"
Mock domain model representing a directed relationship connecting a source and a target entity. 
Used exclusively for unit and integration testing.
"
Class {
	#name : 'OPTestRelationModel',
	#superclass : 'OPTestAbstractModel',
	#instVars : [
		'source',
		'target'
	],
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
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
