"
A palette item used for selecting items in the view.
This class should not be used directly and is created automatically with every DCPalette.
"
Class {
	#name : #OPSelectionTool,
	#superclass : #OPPaletteTool,
	#instVars : [
		'selectedController'
	],
	#category : #'OpenPonk-Spec-Palettes'
}

{ #category : #protocol }
OPSelectionTool >> deselect [
	selectedController hideSelectionFeedback.
	selectedController := OPPaletteNullController new.
	self workbench openFormOn: nil
]

{ #category : #protocol }
OPSelectionTool >> select [
	selectedController := OPPaletteNullController new.
	self diagramController whenHoverChanged: [ :ctrl |  ].
	self diagramController whenSelectionChanged: [ :ctrl | self targetSelected: ctrl ]
]

{ #category : #protocol }
OPSelectionTool >> targetSelected: aController [
	selectedController hideSelectionFeedback.
	(selectedController := aController) showSelectionFeedback.
	self workbench openFormOn: selectedController
]
