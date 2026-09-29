"
Hierarchical abstract node for UI trees with nodes based on model object types
"
Class {
	#name : 'OPModelObjectTypeAbstractNode',
	#superclass : 'Object',
	#traits : 'TComparable',
	#classTraits : 'TComparable classTrait',
	#instVars : [
		'parent'
	],
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'instance creation' }
OPModelObjectTypeAbstractNode class >> withParent: aParentNode fromType: aType [

	^ (aType hasSubtypes
		   ifTrue: [ OPModelObjectTypeNode ]
		   ifFalse: [ OPModelObjectTypeLeafNode ]) withParent: aParentNode fromType: aType
]

{ #category : 'instance creation' }
OPModelObjectTypeAbstractNode class >> withParent: aParent fromTypes: aCollectionOfTypes [
	"accepts a collection of types with same main name, merges subtypes"

	^ self
		  withParent: aParent
		  fromType:
		  (OPModelObjectType
			   named: aCollectionOfTypes anyOne name
			   withSubtypes: (aCollectionOfTypes flatCollect: [ :each | each subtypes ]))
]

{ #category : 'comparing' }
OPModelObjectTypeAbstractNode >> < aComparable [
	"Answer whether the receiver is less than the argument."

	aComparable parent ifNil: [ ^ false ].
	self parent = aComparable parent ifTrue: [ ^ self name < aComparable name ].
	^ self parent < aComparable parent
]

{ #category : 'comparing' }
OPModelObjectTypeAbstractNode >> = aComparable [
	"Compare the receiver with the argument and answer with true if the
	receiver is equal to the argument. Otherwise answer false."

	^ self name = aComparable name and: [ self parent = aComparable parent ]
]

{ #category : 'enumerating' }
OPModelObjectTypeAbstractNode >> allChildren [

	^ self subclassResponsibility
]

{ #category : 'accessing' }
OPModelObjectTypeAbstractNode >> children [

	^ self subclassResponsibility
]

{ #category : 'comparing' }
OPModelObjectTypeAbstractNode >> hash [
	"Hash must be redefined whenever = is redefined."

	^ self name hash bitXor: self parent hash
]

{ #category : 'testing' }
OPModelObjectTypeAbstractNode >> isLeaf [

	^ false
]

{ #category : 'testing' }
OPModelObjectTypeAbstractNode >> matchesType: aType [

	^ aType includesNames: self namesFromRoot
]

{ #category : 'accessing' }
OPModelObjectTypeAbstractNode >> name [

	^ self subclassResponsibility
]

{ #category : 'testing' }
OPModelObjectTypeAbstractNode >> namesFromRoot [

	^ self parent namesFromRoot copyWith: self name
]

{ #category : 'accessing' }
OPModelObjectTypeAbstractNode >> parent [

	^ parent
]

{ #category : 'accessing' }
OPModelObjectTypeAbstractNode >> parent: aParentNode [

	parent := aParentNode
]

{ #category : 'printing' }
OPModelObjectTypeAbstractNode >> printOn: aStream [
	"Append a sequence of characters to aStream that identify the receiver."

	super printOn: aStream.
	aStream
		nextPutAll: ' (';
		nextPutAll: self name asString;
		nextPut: $)
]

{ #category : 'accessing' }
OPModelObjectTypeAbstractNode >> types [

	^ self subclassResponsibility
]

{ #category : 'enumerating' }
OPModelObjectTypeAbstractNode >> withAllChildren [

	^ Array with: self withAll: self allChildren
]
