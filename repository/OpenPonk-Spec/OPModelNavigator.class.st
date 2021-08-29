"
I am a tree view of a model.

To define model-specific mappings subclass OPNavigatorAdapter.


"
Class {
	#name : #OPModelNavigator,
	#superclass : #OPModelTreeWidget,
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #initialization }
OPModelNavigator >> title [
	^ 'Model Tree'
]
