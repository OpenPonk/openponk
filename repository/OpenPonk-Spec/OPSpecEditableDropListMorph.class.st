Class {
	#name : #OPSpecEditableDropListMorph,
	#superclass : #EditableDropListMorph,
	#instVars : [
		'currentIcon'
	],
	#category : #'OpenPonk-Spec-EditableDropList'
}

{ #category : #private }
OPSpecEditableDropListMorph >> getIconFor: anItem [

	^ self model getIconFor: anItem
]

{ #category : #'instance creation' }
OPSpecEditableDropListMorph >> newContentMorph [
	"Answer a new content morph"

	| pt |
	pt := super newContentMorph.
	pt vResizing: #spaceFill.
	pt textMorph
		wrapFlag: false;
		margins:
			(Margin
				left: 5
				top: -2
				right: 0
				bottom: 0).
	^ pt
]

{ #category : #private }
OPSpecEditableDropListMorph >> newListMorph [
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
			roundedCorners: #(2 3);
			setProperty: #morphicLayerNumber toValue: 5;
			borderStyle: (self theme dropListNormalListBorderStyleFor: self);
			on: #mouseDown send: #listMouseDown: to: self;
			yourself
]
