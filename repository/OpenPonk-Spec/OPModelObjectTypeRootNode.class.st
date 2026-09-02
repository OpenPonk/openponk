Class {
	#name : 'OPModelObjectTypeRootNode',
	#superclass : 'OPModelObjectTypeParentNode',
	#category : 'OpenPonk-Spec-Dialogs',
	#package : 'OpenPonk-Spec',
	#tag : 'Dialogs'
}

{ #category : 'instance creation' }
OPModelObjectTypeRootNode class >> withChildrenFromTypes: aCollectionOfTypes [

	^ self new
		  childrenFromTypes: aCollectionOfTypes;
		  yourself
]

{ #category : 'comparing' }
OPModelObjectTypeRootNode >> < aComparable [
	"Answer whether the receiver is less than the argument."

	^ true
]

{ #category : 'accessing' }
OPModelObjectTypeRootNode >> name [

	^ 'All'
]

{ #category : 'testing' }
OPModelObjectTypeRootNode >> namesFromRoot [

	^ #(  )
]
