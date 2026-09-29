"
Spec presenter representing an editable drop-down list. Allows users to either select a predefined item from a list or manually type a custom string.
"
Class {
	#name : 'OPEditableDropListPresenter',
	#superclass : 'SpDropListPresenter',
	#category : 'OpenPonk-Spec-Form',
	#package : 'OpenPonk-Spec',
	#tag : 'Form'
}

{ #category : 'specs' }
OPEditableDropListPresenter class >> adapterName [

	^ #OPMorphicEditableDropListAdapter
]

{ #category : 'api' }
OPEditableDropListPresenter >> items: aList [
	super items: aList asOrderedCollection
]
