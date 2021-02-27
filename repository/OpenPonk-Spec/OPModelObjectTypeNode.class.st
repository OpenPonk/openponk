Class {
	#name : #OPModelObjectTypeNode,
	#superclass : #Object,
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'name',
		'children'
	],
	#category : #'OpenPonk-Spec-Utils'
}

{ #category : #'instance creation' }
OPModelObjectTypeNode class >> fromType: aType [
	^ self new
		name: aType name;
		childrenFromTypes: (aType subtype ifNil: [ {} ] ifNotNil: [ {aType subtype} ]);
		yourself
]

{ #category : #'instance creation' }
OPModelObjectTypeNode class >> fromTypes: aTypesCollection [
	^ (self named: #root withChildrenFromTypes: aTypesCollection)
		children
]

{ #category : #'instance creation' }
OPModelObjectTypeNode class >> named: childName [
	^ self new
		name: childName;
		yourself
]

{ #category : #'instance creation' }
OPModelObjectTypeNode class >> named: childName withChildrenFromTypes: aTypesCollection [
	^ self new
		name: childName;
		childrenFromTypes: aTypesCollection;
		yourself
]

{ #category : #comparing }
OPModelObjectTypeNode >> < aComparable [
	"Answer whether the receiver is less than the argument."

	^ name < aComparable name
]

{ #category : #comparing }
OPModelObjectTypeNode >> = aComparable [
	"Compare the receiver with the argument and answer with true if the 
	receiver is equal to the argument. Otherwise answer false."

	^ name = aComparable name
]

{ #category : #accessing }
OPModelObjectTypeNode >> children [
	^ children
]

{ #category : #accessing }
OPModelObjectTypeNode >> childrenFromTypes: aTypesCollection [
	children := (aTypesCollection groupedBy: #name) associations
		collect: [ :nameAndTypesPair | 
			self class
				named: nameAndTypesPair key
				withChildrenFromTypes: (nameAndTypesPair value collect: #subtype thenReject: #isNil) ]
]

{ #category : #comparing }
OPModelObjectTypeNode >> hash [
	"Hash must be redefined whenever = is redefined."

	^ name hash
]

{ #category : #testing }
OPModelObjectTypeNode >> includesType: aType [
	^ aType withAllSubtypes anySatisfy: [ :any | any name = name ]
]

{ #category : #initialization }
OPModelObjectTypeNode >> initialize [
	super initialize.
	children := Set new
]

{ #category : #accessing }
OPModelObjectTypeNode >> isLeaf [
	^ children isEmpty
]

{ #category : #'as yet unclassified' }
OPModelObjectTypeNode >> leafNames [
	^ children
		ifEmpty: [ Set with: name ]
		ifNotEmpty: [ children flatCollectAsSet: #leafNames ]
]

{ #category : #accessing }
OPModelObjectTypeNode >> name [
	^ name
]

{ #category : #accessing }
OPModelObjectTypeNode >> name: aString [ 
	name := aString
]

{ #category : #printing }
OPModelObjectTypeNode >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: ' (';
		nextPutAll: name asString;
		nextPut: $)
]

{ #category : #'as yet unclassified' }
OPModelObjectTypeNode >> withAllChildren [
	^ (Set with: self) , (children flatCollectAsSet: #withAllChildren)
]
