Class {
	#name : #OPMorphicEditableDropListAdapter,
	#superclass : #SpMorphicDropListAdapter,
	#category : #'OpenPonk-Spec-Form'
}

{ #category : #factory }
OPMorphicEditableDropListAdapter >> addToList: anItem [

	self model addAndSelectItemLabeled: anItem copy do: [  ]
]

{ #category : #factory }
OPMorphicEditableDropListAdapter >> buildWidget [

	self model model whenChangedDo: [ 
		self changed: #getList.
		self changed: #getIndex ].
	self model selection whenChangedDo: [ self changed: #getIndex ].

	^ EditableDropListMorph new
		  wrapSelector: #wrapItem:index:;
		  on: self
		  list: #getList
		  selected: #getIndex
		  changeSelected: #setIndex:;
		  hResizing: #spaceFill;
		  vResizing: #spaceFill;
		  dragEnabled: self dragEnabled;
		  dropEnabled: self dropEnabled;
		  enabled: self enabled;
		  setBalloonText: self help;
		  addToListSel: #addToList:;
		  yourself
]
