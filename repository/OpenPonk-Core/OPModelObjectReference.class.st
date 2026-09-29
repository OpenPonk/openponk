"
Acts as a proxy reference to a model object by encapsulating its UUID.
Utilized during serialization or cross-referencing where the fully resolved object is not immediately accessible.
"
Class {
	#name : 'OPModelObjectReference',
	#superclass : 'Object',
	#instVars : [
		'uuid'
	],
	#category : 'OpenPonk-Core-LegacySupport-Diagrams',
	#package : 'OpenPonk-Core',
	#tag : 'LegacySupport-Diagrams'
}

{ #category : 'as yet unclassified' }
OPModelObjectReference class >> withUUID: aUUID [
	^ self new
		uuid: aUUID;
		yourself
]

{ #category : 'comparing' }
OPModelObjectReference >> = otherModelObject [
	^ self references: otherModelObject
]

{ #category : 'comparing' }
OPModelObjectReference >> hash [

	^ self uuid hash
]

{ #category : 'comparing' }
OPModelObjectReference >> modelObjectFrom: aCollection [

	^ aCollection detect: [ :any | any uuid = uuid ]
]

{ #category : 'printing' }
OPModelObjectReference >> printOn: aStream [
	super printOn: aStream.
	uuid ifNil: [ ^ self ].
	aStream << '(' << uuid asString << ')'
]

{ #category : 'comparing' }
OPModelObjectReference >> references: otherModelObject [
	^ uuid = otherModelObject uuid
]

{ #category : 'accessing' }
OPModelObjectReference >> uuid [
	^ uuid
]

{ #category : 'accessing' }
OPModelObjectReference >> uuid: aUUID [
	uuid := aUUID
]
