"
Tests transactional commands that hide diagram elements while preserving their underlying domain model entities.
"
Class {
	#name : 'OPHideDiagramElementCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'activeProject',
		'containerModel',
		'nodeModel1',
		'nodeModel2',
		'edgeModel',
		'diagramController',
		'undoManager'
	],
	#category : 'OpenPonk-Core-Tests-UndoRedo',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'UndoRedo'
}

{ #category : 'running' }
OPHideDiagramElementCommandTest >> setUp [
	| diagramElement projectController testCanvas |
	super setUp.
	activeProject := OPProject new.
	containerModel := OPTestContainerModel new.
	containerModel instVarNamed: #uuid put: UUID new.
	nodeModel1 := OPTestEntityModel new.
	nodeModel1 instVarNamed: #uuid put: UUID new.
	nodeModel2 := OPTestEntityModel new.
	nodeModel2 instVarNamed: #uuid put: UUID new.
	edgeModel := OPTestRelationModel new.
	edgeModel instVarNamed: #uuid put: UUID new.
	edgeModel source: nodeModel1.
	edgeModel target: nodeModel2.
	containerModel add: nodeModel1.
	containerModel add: nodeModel2.
	containerModel add: edgeModel.
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
	diagramController canvasPresenter: (OPHeadlessCanvasPresenter new canvas: testCanvas; yourself).

	diagramController showInDiagramModel: nodeModel1.
	diagramController showInDiagramModel: nodeModel2.
	diagramController showInDiagramModel: edgeModel
]

{ #category : 'tests' }
OPHideDiagramElementCommandTest >> testHideNodeAndUndoRedo [
	| command node1Element initialBounds |
	node1Element := (diagramController controllerForModel: nodeModel1) diagramElement.
	initialBounds := OPNodeBounds withPosition: 40 @ 40 extent: 60 @ 60.
	node1Element bounds: initialBounds.

	command := OPHideDiagramElementCommand model: nodeModel1 diagramController: diagramController.

	self
		assert: (command class allInstVarNames includes: #diagramController) not
		description: 'Command must not define an instVar for diagramController to prevent history memory leaks'.

	undoManager inTransaction: [ undoManager execute: command ].

	self assert: diagramController controllers size equals: 1.
	self
		assert: (diagramController hasControllerForModel: nodeModel2)
		description: 'Unrelated node2 must remain visible in diagram'.
	self
		deny: (diagramController hasControllerForModel: nodeModel1)
		description: 'Hidden node1 must no longer have a controller in diagram'.
	self
		deny: (diagramController hasControllerForModel: edgeModel)
		description: 'Dependent edge connected to hidden node1 must also be hidden'.

	self assert: containerModel entities size equals: 3.
	self assertCollection: containerModel entities includesAll: { nodeModel1 }.
	self assertCollection: containerModel entities includesAll: { edgeModel }.

	undoManager undo.

	self assert: diagramController controllers size equals: 3.
	self
		assert: (diagramController hasControllerForModel: nodeModel1)
		description: 'Undoing hide command must restore controller for node1'.
	self
		assert: (diagramController hasControllerForModel: edgeModel)
		description: 'Undoing hide command must restore controller for dependent edge'.
	self assert: (diagramController controllerForModel: nodeModel1) diagramElement bounds position equals: 40 @ 40.
	self
		assert: (diagramController controllerForModel: edgeModel) diagramElement source
		equals: (diagramController controllerForModel: nodeModel1) diagramElement.

	undoManager redo.
	self assert: diagramController controllers size equals: 1.
	self
		deny: (diagramController hasControllerForModel: nodeModel1)
		description: 'Redoing hide command must hide node1 again'.
	self
		deny: (diagramController hasControllerForModel: edgeModel)
		description: 'Redoing hide command must hide dependent edge again'.
	self assert: containerModel entities size equals: 3
]
