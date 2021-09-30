Class {
	#name : #OPModelObjectType,
	#superclass : #Object,
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'name',
		'subtype'
	],
	#category : #'OpenPonk-Core-Controllers'
}

{ #category : #'instance creation' }
OPModelObjectType class >> named: aString [
	^ self new
		name: aString;
		yourself
]

{ #category : #'instance creation' }
OPModelObjectType class >> named: aString withSubtype: aType [
	^ (self named: aString)
		subtype: aType;
		yourself
]

{ #category : #comparing }
OPModelObjectType >> < aComparable [
	"Answer whether the receiver is less than the argument."

	^ name < aComparable name
]

{ #category : #comparing }
OPModelObjectType >> = aComparable [
	"Answer whether the receiver and aComparable represent the same object."

	^ self == aComparable
		or: [ self class == aComparable class
				and: [ name = aComparable name
						and: [ (subtype isNil and: [ aComparable subtype isNil ])
								or:
									[ aComparable subtype isNotNil and: [ subtype = aComparable subtype ] ] ] ] ]
]

{ #category : #comparing }
OPModelObjectType >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ name hash
]

{ #category : #'as yet unclassified' }
OPModelObjectType >> mostSpecific [
	subtype ifNil: [ ^ self ].
	^ subtype mostSpecific
]

{ #category : #accessing }
OPModelObjectType >> mostSpecificName [
	subtype ifNil: [ ^ name ].
	^ subtype mostSpecificName
]

{ #category : #accessing }
OPModelObjectType >> name [
	^ name
]

{ #category : #accessing }
OPModelObjectType >> name: aString [
	name := aString
]

{ #category : #printing }
OPModelObjectType >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: ' (';
		nextPutAll: name asString;
		nextPut: $)
]

{ #category : #accessing }
OPModelObjectType >> subtype [
	^ subtype
]

{ #category : #accessing }
OPModelObjectType >> subtype: aType [
	subtype := aType
]

{ #category : #'as yet unclassified' }
OPModelObjectType >> withAllSubtypes [
	| set |
	set := Set with: self.
	subtype ifNil: [ ^ set ].
	^ set , subtype withAllSubtypes
]
