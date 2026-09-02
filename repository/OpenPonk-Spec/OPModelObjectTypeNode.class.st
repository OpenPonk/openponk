"
Hierarchical parent (non-leaf) node for UI trees with nodes based on model object types
"
Class {
	#name : 'OPModelObjectTypeNode',
	#superclass : 'OPModelObjectTypeParentNode',
	#instVars : [
		'name'
	],
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'instance creation' }
OPModelObjectTypeNode class >> withParent: aParentNode fromType: aType [

	^ self withParent: aParentNode name: aType name childrenFromTypes: aType subtypes
]

{ #category : 'instance creation' }
OPModelObjectTypeNode class >> withParent: aParent name: aString childrenFromTypes: aCollectionOfTypes [

	^ self new
		  parent: aParent;
		  name: aString;
		  childrenFromTypes: aCollectionOfTypes;
		  yourself
]

{ #category : 'accessing' }
OPModelObjectTypeNode >> name [

	^ name
]

{ #category : 'accessing' }
OPModelObjectTypeNode >> name: aString [

	name := aString
]
