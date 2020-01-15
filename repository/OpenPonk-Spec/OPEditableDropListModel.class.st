Class {
	#name : #OPEditableDropListModel,
	#superclass : #DropListModel,
	#category : 'OpenPonk-Spec-EditableDropList'
}

{ #category : #specs }
OPEditableDropListModel class >> defaultSpec [
	<spec>
	^ #(OPMorphicEditableDropListAdapter adapt: #(model))
]

{ #category : #api }
OPEditableDropListModel >> items: aList [
	super items: aList asOrderedCollection
]
