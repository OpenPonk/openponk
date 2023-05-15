"
A palette item used for selecting items in the view.
This class should not be used directly and is created automatically with every DCPalette.
"
Class {
	#name : #OPSelectionTool,
	#superclass : #OPPaletteTool,
	#instVars : [
		'selectedControllers'
	],
	#category : #'OpenPonk-Spec-Palettes'
}

{ #category : #protocol }
OPSelectionTool >> deselect [

	self disableMultiselect.
	self selectedControllers: {  }
]

{ #category : #accessing }
OPSelectionTool >> palette: aPalette [

	palette ifNotNil: [ 
		self diagramController ifNotNil: [ :diagramController | 
			diagramController announcer unsubscribe: self ] ].
	super palette: aPalette
]

{ #category : #protocol }
OPSelectionTool >> select [

	self enableMultiselect.
	selectedControllers := {  }
]

{ #category : #protocol }
OPSelectionTool >> selectedControllers: aCollectionOfControllers [

	| originalFigures newFigures |
	originalFigures := selectedControllers collect: #roassalShape.
	newFigures := aCollectionOfControllers collect: #roassalShape.
	originalFigures , newFigures
		detect: #isSelectable
		ifFound: [ :fig | 
			(fig propertyAt: OPRSSelectable) doHighlightShapes: newFigures ].
	selectedControllers := aCollectionOfControllers.
	self editor openFormOn: (aCollectionOfControllers size = 1
			 ifTrue: [ aCollectionOfControllers anyOne ]
			 ifFalse: [ nil ])
]
