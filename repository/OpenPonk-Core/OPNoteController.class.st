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

	(aForm addLongText: 'Text')
		text: self diagramElement text;
		whenTextChangedDo: [ :newValue | 
			self diagramElement text: newValue asString.
			self diagramElement announce:
					(OPElementTextAttributeChanged withAttributeName: #text) ]
]

{ #category : #accessing }
OPNoteController >> diagramElementClass [

	^ OPNote
]

{ #category : #rendering }
OPNoteController >> renderDiagramElement [

	super renderDiagramElement.
	diagramElement announcer
		when: OPElementTextAttributeChanged
		do: [ diagramElement updateRenderFromModel ]
]
