Class {
	#name : #OPEditableDropListPresenter,
	#superclass : #SpDropListPresenter,
	#category : #'OpenPonk-Spec-Form'
}

{ #category : #specs }
OPEditableDropListPresenter class >> adapterName [

	^ #OPMorphicEditableDropListAdapter
]

{ #category : #api }
OPEditableDropListPresenter >> items: aList [
	super items: aList asOrderedCollection
]
