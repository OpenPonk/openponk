Class {
	#name : #OPModelObjectReference,
	#superclass : #Object,
	#instVars : [
		'uuid'
	],
	#category : #'OpenPonk-Core-Diagrams'
}

{ #category : #'as yet unclassified' }
OPModelObjectReference class >> withUUID: aUUID [
	^ self new
		uuid: aUUID;
		yourself
]

{ #category : #comparing }
OPModelObjectReference >> = otherModelObject [
	^ self references: otherModelObject
]

{ #category : #printing }
OPModelObjectReference >> printOn: aStream [
	super printOn: aStream.
	uuid ifNil: [ ^ self ].
	aStream << '(' << uuid asString << ')'
]

{ #category : #comparing }
OPModelObjectReference >> references: otherModelObject [
	^ uuid = otherModelObject uuid
]

{ #category : #accessing }
OPModelObjectReference >> uuid [
	^ uuid
]

{ #category : #accessing }
OPModelObjectReference >> uuid: aUUID [
	uuid := aUUID
]
