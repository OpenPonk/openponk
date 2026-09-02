Class {
	#name : 'OPModelObjectType',
	#superclass : 'Object',
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'name',
		'subtypes'
	],
	#category : 'OpenPonk-Core-ViewModels',
	#package : 'OpenPonk-Core',
	#tag : 'ViewModels'
}

{ #category : 'instance creation' }
OPModelObjectType class >> named: aString [
	^ self new
		name: aString;
		yourself
]

{ #category : 'instance creation' }
OPModelObjectType class >> named: aString withSubtype: aType [

	^ (self named: aString withSubtypes: { aType }) f
]

{ #category : 'instance creation' }
OPModelObjectType class >> named: aString withSubtypes: aTypeCollection [

	^ (self named: aString)
		  addSubtypes: aTypeCollection;
		  yourself
]

{ #category : 'comparing' }
OPModelObjectType >> < aComparable [
	"Answer whether the receiver is less than the argument."

	name = aComparable name ifFalse: [ ^ name < aComparable name ].
	subtypes withIndexDo: [ :each :index |
			aComparable subtypes size < index ifTrue: [ ^ false ].
			each = (aComparable subtypes at: index) ifFalse: [ ^ each < (aComparable subtypes at: index) ] ].
	^ subtypes size ~= aComparable subtypes size
]

{ #category : 'comparing' }
OPModelObjectType >> = aComparable [
	"Answer whether the receiver and aComparable represent the same object."

	^ name = aComparable name and: [ subtypes = aComparable subtypes ]
]

{ #category : 'accessing' }
OPModelObjectType >> addSubtypes: aCollectionOfTypes [

	subtypes addAll: aCollectionOfTypes
]

{ #category : 'testing' }
OPModelObjectType >> hasSubtypes [

	^ subtypes isNotEmpty
]

{ #category : 'comparing' }
OPModelObjectType >> hash [
	"Answer an integer value that is related to the identity of the receiver."

	^ name hash bitXor: (subtypes ifNotEmpty: [ :subs | subs first ]) hash
]

{ #category : 'testing' }
OPModelObjectType >> includesNames: aCollectionOfNames [

	| aCollectionOfSubtypeNames |
	aCollectionOfNames ifEmpty: [ ^ true ].
	self name = aCollectionOfNames first ifFalse: [ ^ false ].
	aCollectionOfSubtypeNames := aCollectionOfNames copyWithoutFirst.
	aCollectionOfSubtypeNames ifEmpty: [ ^ true ].
	^ self subtypes anySatisfy: [ :any | any includesNames: aCollectionOfSubtypeNames ]
]

{ #category : 'as yet unclassified' }
OPModelObjectType >> includesTypeNode: aTypeNode [

	^ self subtypes anySatisfy: [ :any | any includesTypeNode: aTypeNode ]
]

{ #category : 'initialization' }
OPModelObjectType >> initialize [

	super initialize.
	subtypes := SortedCollection new
]

{ #category : 'accessing' }
OPModelObjectType >> name [
	^ name
]

{ #category : 'accessing' }
OPModelObjectType >> name: aString [
	name := aString
]

{ #category : 'printing' }
OPModelObjectType >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: ' (';
		nextPutAll: name asString;
		nextPut: $)
]

{ #category : 'printing' }
OPModelObjectType >> printWithNameSeparator: aNameSeparator subtypesSeparator: aSubtypesSeparator [

	^ String streamContents: [ :s | self printWithNameSeparator: aNameSeparator subtypesSeparator: aSubtypesSeparator on: s ]
]

{ #category : 'printing' }
OPModelObjectType >> printWithNameSeparator: aNameSeparator subtypesSeparator: aSubtypesSeparator on: aStream [

	aStream nextPutAll: self name.
	subtypes ifEmpty: [ ^ self ].
	aStream << aNameSeparator.
	subtypes do: [ :each | aStream nextPutAll: each name ] separatedBy: [ aStream << aSubtypesSeparator ]
]

{ #category : 'accessing' }
OPModelObjectType >> subtypes [

	^ subtypes
]
