Class {
	#name : #OPMorphicEditableDropListAdapter,
	#superclass : #MorphicDropListAdapter,
	#category : #'OpenPonk-Spec-EditableDropList'
}

{ #category : #factory }
OPMorphicEditableDropListAdapter >> addToList: anItem [
	self model addSilentlyItemLabeled: anItem do: [  ].
	self model setSelectedItem: anItem
]

{ #category : #factory }
OPMorphicEditableDropListAdapter >> buildWidget [
	^ OPSpecEditableDropListMorph new
		wrapSelector: #wrapItem:index:;
		on: self
			list: #getList
			selected: #getIndex
			changeSelected: #setIndex:;
		hResizing: #spaceFill;
		vResizing: #spaceFill;
		addToListSel: #addToList:;
		yourself
]
