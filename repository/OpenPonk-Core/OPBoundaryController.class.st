Class {
	#name : #OPBoundaryController,
	#superclass : #OPCommonElementController,
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #'as yet unclassified' }
OPBoundaryController class >> paletteItemName [
	^ #boundary
]

{ #category : #forms }
OPBoundaryController >> buildEditorForm: aForm [
	(aForm addText: 'Name')
		text: self model name;
		whenTextIsAccepted: [ :newValue | 
			self model name: newValue asString.
			self refreshFigure ]
]
