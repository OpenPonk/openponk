Class {
	#name : #OPEditableDropListPresenter,
	#superclass : #DropListPresenter,
	#category : #'OpenPonk-Spec-EditableDropList'
}

{ #category : #specs }
OPEditableDropListPresenter class >> defaultSpec [
	<spec>
	^ #(OPMorphicEditableDropListAdapter adapt: #(model))
]

{ #category : #api }
OPEditableDropListPresenter >> items: aList [
	super items: aList asOrderedCollection
]
