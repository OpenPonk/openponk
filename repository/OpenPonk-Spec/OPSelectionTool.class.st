"
A palette item used for selecting items in the view.
This class should not be used directly and is created automatically with every DCPalette.
"
Class {
	#name : 'OPSelectionTool',
	#superclass : 'OPPaletteTool',
	#instVars : [
		'selectedControllers'
	],
	#category : 'OpenPonk-Spec-Palettes',
	#package : 'OpenPonk-Spec',
	#tag : 'Palettes'
}

{ #category : 'protocol' }
OPSelectionTool >> deselect [

	self disableMultiselect.
	self selectedControllers: {  }
]

{ #category : 'accessing' }
OPSelectionTool >> palette: aPalette [

	palette ifNotNil: [ 
		self diagramController ifNotNil: [ :diagramController | 
			diagramController announcer unsubscribe: self ] ].
	super palette: aPalette
]

{ #category : 'protocol' }
OPSelectionTool >> select [

	self enableMultiselect.
	selectedControllers := {  }
]

{ #category : 'protocol' }
OPSelectionTool >> selectedControllers: aCollectionOfControllers [

	| originalRoassalShapes newRoassalShapes |
	originalRoassalShapes := selectedControllers
		                         select: #isRendered
		                         thenCollect: #roassalShape.
	newRoassalShapes := aCollectionOfControllers collect: #roassalShape.
	originalRoassalShapes , newRoassalShapes
		detect: #isSelectable
		ifFound: [ :shape |
			(shape propertyAt: OPRSSelectable) doHighlightShapes:
				newRoassalShapes ].
	selectedControllers := aCollectionOfControllers.
	self editor openFormOn: (aCollectionOfControllers size = 1
			 ifTrue: [ aCollectionOfControllers anyOne ]
			 ifFalse: [ nil ])
]
