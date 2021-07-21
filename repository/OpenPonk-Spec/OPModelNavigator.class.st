"
I am a tree view of a model.

To define model-specific mappings subclass OPNavigatorAdapter.


"
Class {
	#name : #OPModelNavigator,
	#superclass : #OPModelTreeWidget,
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #specs }
OPModelNavigator class >> withoutHeadingSpec [
	^ SpecColumnLayout composed
		add: #tree;
		yourself
]

{ #category : #initialization }
OPModelNavigator >> title [
	^ 'Model Tree'
]
