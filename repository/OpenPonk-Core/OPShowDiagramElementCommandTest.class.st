Class {
	#name : 'OPShowDiagramElementCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'activeProject',
		'containerModel',
		'hiddenNodeModel',
		'diagramController',
		'undoManager'
	],
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'running' }
OPShowDiagramElementCommandTest >> setUp [
	| diagramElement projectController testCanvas |
	super setUp.
	activeProject := OPProject new.
	containerModel := OPTestContainerModel new.
	containerModel instVarNamed: #uuid put: UUID new.
	hiddenNodeModel := OPTestEntityModel new.
	hiddenNodeModel instVarNamed: #uuid put: UUID new.
	containerModel add: hiddenNodeModel.
	activeProject addModel: containerModel.

	testCanvas := RSCanvas new.
	diagramElement := OPOpenPonkDiagram forModelElement: containerModel.
	diagramElement canvas: testCanvas.

	undoManager := OPUndoManager new.
	projectController := OPProjectController forProject: activeProject.
	projectController instVarNamed: #undoManager put: undoManager.

	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController model: containerModel.
	diagramController diagramElement: diagramElement.
	diagramController canvasPresenter: (OPCanvasPresenter new canvas: testCanvas; yourself)
]

{ #category : 'tests' }
OPShowDiagramElementCommandTest >> testShowNodeAndUndoRedo [
	| command |
	"Initially, the node is in the domain but not shown in the diagram"
	self assert: diagramController controllers isEmpty.
	self assert: containerModel entities size equals: 1.

	command := OPShowDiagramElementCommand
		model: hiddenNodeModel
		diagramController: diagramController.

	self assert: (command class allInstVarNames includes: #diagramController) not
		description: 'Command must not define an instVar for diagramController to prevent history memory leaks'.

	undoManager inTransaction: [ undoManager execute: command ].

	"Node must now be shown"
	self assert: diagramController controllers size equals: 1.
	self assert: (diagramController hasControllerForModel: hiddenNodeModel).

	"Undo must hide the element"
	undoManager undo.
	self assert: diagramController controllers isEmpty.
	self deny: (diagramController hasControllerForModel: hiddenNodeModel).
	self assert: containerModel entities size equals: 1.

	"Redo must show it again"
	undoManager redo.
	self assert: diagramController controllers size equals: 1.
	self assert: (diagramController hasControllerForModel: hiddenNodeModel)
]
