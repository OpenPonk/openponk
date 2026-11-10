"
Tests diagram element exploration, tree navigation, and visibility toggle operations in the diagram explorer.
"
Class {
	#name : 'OPDiagramExplorerTest',
	#superclass : 'TestCase',
	#instVars : [
		'activeProject',
		'containerModel',
		'nodeModel1',
		'nodeModel2',
		'edgeModel',
		'diagramController',
		'undoManager',
		'explorer',
		'projectController'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'accessing' }
OPDiagramExplorerTest >> explorer [ ^ explorer
]

{ #category : 'running' }
OPDiagramExplorerTest >> setUp [
	| diagramElement testCanvas |
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
	projectController := OPProjectController new.
	projectController project: activeProject.
	projectController instVarNamed: #undoManager put: undoManager.

	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController model: containerModel.
	diagramController diagramElement: diagramElement.
	diagramController canvasPresenter: (OPCanvasPresenter new canvas: testCanvas; yourself).

	diagramController showInDiagramModel: nodeModel1.
	diagramController showInDiagramModel: nodeModel2.
	diagramController showInDiagramModel: edgeModel.

	explorer := OPDiagramExplorer on: diagramController
]

{ #category : 'tests' }
OPDiagramExplorerTest >> testDiagramOnlyElementsCreationPriority [
	self assert: OPBoundaryViewModel new creationPriority equals: 5.
	self assert: OPNoteViewModel new creationPriority equals: 10
]

{ #category : 'tests' }
OPDiagramExplorerTest >> testExplorerFailsFastWithoutUndoManager [
	diagramController projectController: nil.

	self
		should: [ explorer hideElement: nodeModel1 ]
		raise: MessageNotUnderstood
]

{ #category : 'tests - undo/redo' }
OPDiagramExplorerTest >> testHideAllElementsExecutesInUndoTransaction [
	| initialCommandsCount |
	initialCommandsCount := diagramController undoManager undoStack size.
	explorer hideAllElements.
	self assert: diagramController undoManager undoStack size > initialCommandsCount
		description: 'hideAllElements must record command into undoManager'
]

{ #category : 'tests' }
OPDiagramExplorerTest >> testHideElementAndUndo [
	self assert: diagramController controllers size equals: 3.
	explorer hideElement: nodeModel1.
	self assert: diagramController controllers size equals: 1.
	self assert: (diagramController controllerForModel: nodeModel1 ifNone: [ nil ]) isNil
		description: 'Hidden node1 should not have a controller'.
	undoManager undo.
	self assert: diagramController controllers size equals: 3.
	self assert: (diagramController controllerForModel: nodeModel1 ifNone: [ nil ]) isNotNil
		description: 'Undoing hide should restore node1 controller'.
	self assert: (diagramController controllerForModel: edgeModel ifNone: [ nil ]) isNotNil
		description: 'Undoing hide should restore connected edge controller'
]

{ #category : 'tests' }
OPDiagramExplorerTest >> testHideMultipleElementsInSingleTransaction [
	self assert: diagramController controllers size equals: 3.
	explorer hideElements: { nodeModel1 . nodeModel2 }.
	self assertEmpty: diagramController controllers.
	undoManager undo.
	self assert: diagramController controllers size equals: 3.
	self assert: (diagramController controllerForModel: nodeModel1 ifNone: [ nil ]) isNotNil
		description: 'Node 1 controller should be restored after undo'.
	self assert: (diagramController controllerForModel: nodeModel2 ifNone: [ nil ]) isNotNil
		description: 'Node 2 controller should be restored after undo'.
	self assert: (diagramController controllerForModel: edgeModel ifNone: [ nil ]) isNotNil
		description: 'Edge controller should be restored after undo'.
	undoManager redo.
	self assertEmpty: diagramController controllers
]

{ #category : 'tests' }
OPDiagramExplorerTest >> testShowAndHideRootModelAndDependentsAndIdempotentShow [
	self assert: explorer diagramController identicalTo: diagramController.
	self denyEmpty: (explorer dependentFor: containerModel).

	explorer showElements: { nodeModel1 }.
	self assert: diagramController controllers size equals: 3.

	explorer hideElement: containerModel.
	self assertEmpty: diagramController controllers.

	explorer showElement: containerModel.
	self assert: diagramController controllers size equals: 3.

	explorer hideDependentFor: containerModel.
	self assertEmpty: diagramController controllers.

	explorer showDependentFor: containerModel.
	self assert: diagramController controllers size equals: 3
]

{ #category : 'tests' }
OPDiagramExplorerTest >> testShowElementAndUndo [
	| hiddenNode |
	hiddenNode := OPTestEntityModel new.
	hiddenNode instVarNamed: #uuid put: UUID new.
	containerModel add: hiddenNode.
	self assert: (diagramController controllerForModel: hiddenNode ifNone: [ nil ]) isNil
		description: 'Newly added model element should not have a controller before showElement:'.
	explorer showElement: hiddenNode.
	self assert: (diagramController controllerForModel: hiddenNode ifNone: [ nil ]) isNotNil
		description: 'showElement: should create and attach a controller for hiddenNode'.
	undoManager undo.
	self assert: (diagramController controllerForModel: hiddenNode ifNone: [ nil ]) isNil
		description: 'Undoing showElement: should remove the controller'
]

{ #category : 'accessing' }
OPDiagramExplorerTest >> undoManager [ ^ undoManager
]
