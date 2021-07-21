"
I am a scrolling wrapper around DynamicForm.
"
Class {
	#name : #OPScrollableForm,
	#superclass : #ComposablePresenter,
	#instVars : [
		'form',
		'scrollPane'
	],
	#category : #'OpenPonk-Spec-Form'
}

{ #category : #specs }
OPScrollableForm class >> defaultSpec [
	^ SpecLayout composed
		add: #scrollPane;
		yourself
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

{ #category : #initialization }
OPScrollableForm >> initializeWidgets [
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
