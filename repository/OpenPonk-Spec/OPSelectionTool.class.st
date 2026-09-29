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

{ #category : 'hooks' }
OPSelectionTool >> deselectController: aController [
	"Deselect aController if present, update canvas highlights, and synchronize the workbench form."
	(self selectedControllers includes: aController) ifFalse: [ ^ self ].
	self selectedControllers: (self selectedControllers copyWithout: aController)
]

{ #category : 'initialization' }
OPSelectionTool >> initialize [
	super initialize.
	selectedControllers := #( )
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

{ #category : 'accessing' }
OPSelectionTool >> selectedControllers [
	"Answer the collection of currently selected controllers."
	^ selectedControllers ifNil: [ selectedControllers := #( ) ]
]

{ #category : 'hooks' }
OPSelectionTool >> selectedControllers: aCollectionOfControllers [
	| originalRoassalShapes newRoassalShapes |
	originalRoassalShapes := self selectedControllers
		                         select: [ :eachController | eachController isRendered ]
		                         thenCollect: [ :eachController | eachController roassalShape ].
	newRoassalShapes := aCollectionOfControllers
		                    select: [ :eachController | eachController isRendered ]
		                    thenCollect: [ :eachController | eachController roassalShape ].
	originalRoassalShapes , newRoassalShapes
		detect: #isSelectable
		ifFound: [ :foundShape |
			(foundShape propertyAt: OPRSSelectable) doHighlightShapes:
				newRoassalShapes ].
	selectedControllers := aCollectionOfControllers.
	self workbench openFormOn:
		(aCollectionOfControllers size = 1 ifTrue: [
			 aCollectionOfControllers anyOne ])
]
