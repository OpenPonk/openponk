"
I am a scrolling wrapper around DynamicForm.
"
Class {
	#name : #OPScrollableForm,
	#superclass : #SpPresenter,
	#instVars : [
		'form',
		'scrollPane'
	],
	#category : #'OpenPonk-Spec-Form'
}

{ #category : #'as yet unclassified' }
OPScrollableForm class >> defaultLayout [

	^ SpBoxLayout newLeftToRight
		  add: #scrollPane;
		  yourself
]

{ #category : #specs }
OPScrollableForm class >> defaultSpec [

	self flag: 'Pharo 9- compatibility'.
	^ self defaultLayout
]

{ #category : #'reflective operations' }
OPScrollableForm >> doesNotUnderstand: aMessage [
	^ aMessage sendTo: form
]

{ #category : #public }
OPScrollableForm >> editController: aController [
	form editController: aController
]

{ #category : #accessing }
OPScrollableForm >> form [
	^ form
]

{ #category : #'as yet unclassified' }
OPScrollableForm >> initializePresenters [
	form := self instantiate: OPDynamicForm.
	scrollPane := (self newScrollPaneFor: form) asSpecAdapter
]

{ #category : #'instance creation' }
OPScrollableForm >> newScrollPaneFor: aForm [
	| scrollpane |
	scrollpane := GeneralScrollPane new.
	scrollpane changeScrollerTableLayout.
	aForm buildWithSpec.
	"	aForm rebuildWidget."
	scrollpane scrollTarget: aForm widget widget.
	scrollpane
		hResizing: #spaceFill;
		vResizing: #spaceFill.
	^ scrollpane
]

{ #category : #accessing }
OPScrollableForm >> scrollPane [
	^ scrollPane
]
