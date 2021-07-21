"
I am a scrolling wrapper around Palette.
"
Class {
	#name : #OPScrollablePalette,
	#superclass : #ComposablePresenter,
	#instVars : [
		'palette',
		'scrollPane'
	],
	#category : #'OpenPonk-Spec-Palettes'
}

{ #category : #specs }
OPScrollablePalette class >> defaultSpec [
	^ SpecLayout composed
		add: #scrollPane;
		yourself
]

{ #category : #accessing }
OPScrollablePalette >> doesNotUnderstand: aMessage [
	^ aMessage sendTo: palette
]

{ #category : #accessing }
OPScrollablePalette >> initializeWidgets [
	palette := self instantiate: OPPalette.
	scrollPane := (self newScrollPaneFor: palette) asSpecAdapter
]

{ #category : #'instance creation' }
OPScrollablePalette >> newScrollPaneFor: aForm [
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
OPScrollablePalette >> palette [
	^ palette
]

{ #category : #'instance creation' }
OPScrollablePalette >> scrollPane [
	^ scrollPane
]

{ #category : #accessing }
OPScrollablePalette >> workbench [
	^ owner workbench
]
