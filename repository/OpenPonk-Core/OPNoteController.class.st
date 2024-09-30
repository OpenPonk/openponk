Class {
	#name : 'OPNoteController',
	#superclass : 'OPCommonElementController',
	#traits : 'OPTResizableFigureController',
	#classTraits : 'OPTResizableFigureController classTrait',
	#category : 'OpenPonk-Core-CommonElements',
	#package : 'OpenPonk-Core',
	#tag : 'CommonElements'
}

{ #category : 'as yet unclassified' }
OPNoteController class >> paletteItemName [
	^ #note
]

{ #category : 'forms' }
OPNoteController >> buildEditorForm: aForm [

	(aForm addLongText: 'Text')
		text: self diagramElement text;
		whenTextChangedDo: [ :newValue | 
			self diagramElement text: newValue asString.
			self diagramElement updateText ]
]

{ #category : 'construction' }
OPNoteController >> diagramElementClass [

	^ OPNote
]

{ #category : 'construction' }
OPNoteController >> renderDiagramElement [

	super renderDiagramElement.
	diagramElement announcer
		when: OPElementTextAttributeChanged
		send: #updateRenderFromSelf
		to: diagramElement.
	^ self roassalShape
]
