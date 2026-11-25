"
Tests transactional commands that unhide and render hidden model elements on a diagram canvas.
"
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
	#category : 'OpenPonk-Core-Tests-UndoRedo',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'UndoRedo'
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
	diagramController canvasPresenter: (OPHeadlessCanvasPresenter new canvas: testCanvas; yourself)
]

{ #category : 'tests' }
OPShowDiagramElementCommandTest >> testExecuteIgnoresNoShapeDiagramElement [

	| noShapeController command |
	noShapeController := OPTestEntityController new.
	(diagramController stub showWithoutDependentInDiagramModel: hiddenNodeModel) willReturn: noShapeController.

	command := OPShowDiagramElementCommand model: hiddenNodeModel diagramController: diagramController.

	undoManager execute: command.

	self assert: command model identicalTo: hiddenNodeModel.
	self assert: command diagramController identicalTo: diagramController
]

{ #category : 'tests' }
OPShowDiagramElementCommandTest >> testShowNodeAndUndoRedo [

	| command |
	self assertEmpty: diagramController controllers.
	self assert: containerModel entities size equals: 1.

	command := OPShowDiagramElementCommand model: hiddenNodeModel diagramController: diagramController.

	undoManager inTransaction: [ undoManager execute: command ].

	self assert: diagramController controllers size equals: 1.
	self
		assert: (diagramController hasControllerForModel: hiddenNodeModel)
		description: 'Diagram controller should have a controller for the shown node'.

	undoManager undo.
	self assertEmpty: diagramController controllers.
	self
		deny: (diagramController hasControllerForModel: hiddenNodeModel)
		description: 'Undoing show command must hide the node controller from diagram'.
	self assert: containerModel entities size equals: 1.

	undoManager redo.
	self assert: diagramController controllers size equals: 1.
	self
		assert: (diagramController hasControllerForModel: hiddenNodeModel)
		description: 'Redoing show command must show the node controller in diagram again'
]

{ #category : 'tests' }
OPShowDiagramElementCommandTest >> testUndoRedoWorksAfterClosingAndReopeningDiagramWithNewController [

	| command projectController diagram reopenedCanvas reopenedDiagramController |
	command := OPShowDiagramElementCommand model: hiddenNodeModel diagramController: diagramController.
	undoManager inTransaction: [ undoManager execute: command ].
	self assert: diagramController controllers size equals: 1.

	projectController := diagramController projectController.
	diagram := diagramController diagramElement.
	projectController removeDiagramController: diagramController.
	diagramController removeAllControllers.
	diagramController removeRender.

	reopenedCanvas := RSCanvas new.
	diagram canvas: reopenedCanvas.
	reopenedDiagramController := OPTestDiagramController new.
	projectController addDiagramController: reopenedDiagramController.
	reopenedDiagramController model: containerModel.
	reopenedDiagramController diagramElement: diagram.
	reopenedDiagramController canvasPresenter: (OPHeadlessCanvasPresenter new
			 canvas: reopenedCanvas;
			 yourself).
	reopenedDiagramController showDiagramElement: diagram.

	self assert: command openDiagramController identicalTo: reopenedDiagramController.
	self assert: reopenedDiagramController controllers size equals: 1.
	self assertEmpty: diagramController controllers.

	undoManager undo.
	self assertEmpty: reopenedDiagramController controllers.
	self
		deny: (reopenedDiagramController hasControllerForModel: hiddenNodeModel)
		description: 'Undoing show after reopen must hide the node on the new diagram controller'.
	self assertEmpty: diagramController controllers.

	undoManager redo.
	self assert: reopenedDiagramController controllers size equals: 1.
	self
		assert: (reopenedDiagramController hasControllerForModel: hiddenNodeModel)
		description: 'Redoing show after reopen must restore the node on the new diagram controller'.
	self assertEmpty: diagramController controllers
]
