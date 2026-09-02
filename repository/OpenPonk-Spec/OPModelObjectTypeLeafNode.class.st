"
Hierarchical leaf node for UI trees with nodes based on model object types
"
Class {
	#name : 'OPModelObjectTypeLeafNode',
	#superclass : 'OPModelObjectTypeAbstractNode',
	#instVars : [
		'type'
	],
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'instance creation' }
OPModelObjectTypeLeafNode class >> withParent: aParentNode fromType: aType [

	^ self new
		  parent: aParentNode;
		  type: aType;
		  yourself
]

{ #category : 'enumerating' }
OPModelObjectTypeLeafNode >> allChildren [

	^ #(  )
]

{ #category : 'accessing' }
OPModelObjectTypeLeafNode >> children [

	^ #(  )
]

{ #category : 'testing' }
OPModelObjectTypeLeafNode >> isLeaf [

	^ true
]

{ #category : 'accessing' }
OPModelObjectTypeLeafNode >> name [

	^ type name
]

{ #category : 'accessing' }
OPModelObjectTypeLeafNode >> type: aType [

	type := aType
]

{ #category : 'accessing' }
OPModelObjectTypeLeafNode >> types [

	^ { type }
]
