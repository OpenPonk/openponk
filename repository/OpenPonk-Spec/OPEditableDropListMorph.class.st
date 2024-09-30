Class {
	#name : 'OPEditableDropListMorph',
	#superclass : 'EditableDropListMorph',
	#category : 'OpenPonk-Spec-Form',
	#package : 'OpenPonk-Spec',
	#tag : 'Form'
}

{ #category : 'configuring' }
OPEditableDropListMorph >> configureWith: displayModel item: itemPresenter [
	displayModel configureDropList: self item: itemPresenter
]

{ #category : 'testing' }
OPEditableDropListMorph >> hasKeyboardFocus [

	^ (contentMorph ifNil: [ ^ false ]) hasKeyboardFocus
]

{ #category : 'private' }
OPEditableDropListMorph >> listHeight [
	"Answer the height for the list."

	^ super listHeight + 12
]

{ #category : 'instance creation' }
OPEditableDropListMorph >> newListMorph [

	"Answer a new list morph"

	^ (self listMorphClass
		   on: self
		   list: #list
		   selected: #listSelectionIndex
		   changeSelected: #listSelectionIndex:
		   menu: nil
		   keystroke: nil)
		  autoDeselect: false;
		  wrapSelector: #wrapItem:index:;
		  roundedCorners: #( 2 3 );
		  setProperty: #morphicLayerNumber toValue: 5;
		  borderStyle: (self theme dropListNormalListBorderStyleFor: self);
		  on: #mouseDown send: #listMouseDown: to: self;
		  yourself
]

{ #category : 'wrapping' }
OPEditableDropListMorph >> wrapItem: anItem index: anIndex [

	^ self model wrapItem: anItem index: anIndex
]
