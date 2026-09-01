"
Palette tool dedicated to selecting and highlighting existing items on the diagram canvas. 
Typically the default active tool in any OpenPonk palette.
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

{ #category : 'hooks' }
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
	self workbench openFormOn:
		(aCollectionOfControllers size = 1 ifTrue: [
			 aCollectionOfControllers anyOne ])
]
