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
		whenTextChangedDo: [ :newValue | 
			self model text: newValue asString.
			self model announce:
					(OPElementTextAttributeChanged withAttributeName: #text) ]
]

{ #category : #construction }
OPNoteController >> createModelIn: aParentModel [
	super createModelIn: aParentModel.
	model
		when: OPElementTextAttributeChanged
		do: [ self figure updateText ].
	^ model
]

{ #category : #accessing }
OPNoteController >> modelClass [
	^ OPNote
]

{ #category : #construction }
OPNoteController >> removeModel [
	model announcer unsubscribe: self.
	super removeModel
]

{ #category : #construction }
OPNoteController >> renderFigureIn: aView [
	self diagramController addingFigureFor: self.
	figure := OPNoteFigure on: self model.
	figure renderIn: aView.
	^ self diagramController addedFigureFor: self
]
