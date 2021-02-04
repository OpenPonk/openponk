Class {
	#name : #OPNoteController,
	#superclass : #OPCommonElementController,
	#traits : 'OPTResizableFigureController',
	#classTraits : 'OPTResizableFigureController classTrait',
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

{ #category : #accessing }
OPNoteController >> modelClass [
	^ OPNote
]

{ #category : #construction }
OPNoteController >> renderFigureIn: aView [
	self diagramController addingFigureFor: self.
	figure := OPNoteFigure on: self model.
	figure renderIn: aView.
	^ self diagramController addedFigureFor: self
]
