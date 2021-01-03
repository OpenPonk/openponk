Class {
	#name : #OPNoteController,
	#superclass : #OPCommonElementController,
	#category : #'OpenPonk-Core-CommonElements'
}

{ #category : #'as yet unclassified' }
OPNoteController class >> paletteItemName [
	^ #note
]

{ #category : #forms }
OPNoteController >> buildEditorForm: aForm [
	(aForm addText: 'Text')
		text: self model text;
		whenTextIsAccepted: [ :newValue | 
			self model text: newValue asString.
			self refreshFigure ]
]
