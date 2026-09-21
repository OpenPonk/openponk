"
I am an abstract base class for commands that target a specific diagram within an OpenPonk project.

I hold persistent references to the domain diagram model (diagram) and the active project controller (projectController). I dynamically resolve the active diagram controller via #openDiagramController when the diagram is currently open (rendered in canvas), and cleanly handle commands executed when the diagram is closed.
"
Class {
	#name : 'OPDiagramCommand',
	#superclass : 'OPCommand',
	#instVars : [
		'model',
		'diagram',
		'projectController'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'accessing' }
OPDiagramCommand >> diagram [
	^ diagram
]

{ #category : 'accessing' }
OPDiagramCommand >> diagram: anOPDiagram [
	diagram := anOPDiagram
]

{ #category : 'accessing' }
OPDiagramCommand >> model [
	^ model
]

{ #category : 'accessing' }
OPDiagramCommand >> openDiagramController [
	"Answer the currently active diagram controller if the diagram is open (rendered), or nil if closed."
	diagram isRendered ifFalse: [ ^ nil ].
	projectController ifNil: [ ^ nil ].
	^ projectController controllers
		detect: [ :eachController | eachController diagramElement == diagram ]
		ifNone: [ nil ]
]

{ #category : 'accessing' }
OPDiagramCommand >> projectController [
	^ projectController
]

{ #category : 'accessing' }
OPDiagramCommand >> projectController: anOPProjectController [
	projectController := anOPProjectController
]
