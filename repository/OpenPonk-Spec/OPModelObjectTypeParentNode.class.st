Class {
	#name : 'OPModelObjectTypeParentNode',
	#superclass : 'OPModelObjectTypeAbstractNode',
	#instVars : [
		'children'
	],
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'enumerating' }
OPModelObjectTypeParentNode >> allChildren [

	^ self children flatCollect: [ :each | each withAllChildren ]
]

{ #category : 'accessing' }
OPModelObjectTypeParentNode >> children [
	^ children
]

{ #category : 'accessing' }
OPModelObjectTypeParentNode >> childrenFromTypes: aTypesCollection [

	| childrenSet |
	childrenSet := Set new.
	(aTypesCollection groupedBy: [ :each | each name ]) keysAndValuesDo: [ :eachName :eachSubtypesCollection |
		childrenSet add: (OPModelObjectTypeAbstractNode withParent: self fromTypes: eachSubtypesCollection) ].
	children := childrenSet asSortedCollection
]

{ #category : 'accessing' }
OPModelObjectTypeParentNode >> types [

	^ self children flatCollect: [ :each | each types ]
]
