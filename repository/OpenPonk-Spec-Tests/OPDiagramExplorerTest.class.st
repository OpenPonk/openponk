"
Tests diagram element exploration, tree navigation, and visibility toggle operations in the diagram explorer.
"
Class {
	#name : 'OPDiagramExplorerTest',
	#superclass : 'TestCase',
	#instVars : [
		'containerModel',
		'nodeModel1',
		'nodeModel2',
		'edgeModel',
		'diagramController',
		'undoManager',
		'explorer',
		'projectController'
	],
	#category : 'OpenPonk-Spec-Tests-Dialogs',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Dialogs'
}

{ #category : 'accessing' }
OPDiagramExplorerTest >> explorer [ ^ explorer
]

{ #category : 'running' }
OPDiagramExplorerTest >> setUp [

	| activeProject diagramElement testCanvas |
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
	diagramController canvasPresenter: (OPCanvasPresenter new
			 canvas: testCanvas;
			 yourself).

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
	self assert: diagramController undoManager undoStack size equals: initialCommandsCount + 1
]

{ #category : 'tests' }
OPDiagramExplorerTest >> testHideAndShowElementsNoOpOnEmptyOrHiddenCollections [

	| initialUndoCount hiddenNode |
	initialUndoCount := undoManager undoStack size.
	hiddenNode := OPTestEntityModel new.
	hiddenNode instVarNamed: #uuid put: UUID new.
	containerModel add: hiddenNode.

	explorer hideElements: #(  ).
	explorer hideElements: { hiddenNode }.
	explorer showElements: #(  ).

	self assert: undoManager undoStack size equals: initialUndoCount.
	self assert: diagramController controllers size equals: 3
]

{ #category : 'tests' }
OPDiagramExplorerTest >> testHideElementAndUndo [

	| restoredNodeController restoredEdgeController |
	self assert: diagramController controllers size equals: 3.
	explorer hideElement: nodeModel1.
	self assert: diagramController controllers size equals: 1.
	self assert: (diagramController controllerForModel: nodeModel1 ifNone: [ nil ]) identicalTo: nil.
	undoManager undo.
	self assert: diagramController controllers size equals: 3.
	restoredNodeController := diagramController controllerForModel: nodeModel1 ifNone: [ nil ].
	restoredEdgeController := diagramController controllerForModel: edgeModel ifNone: [ nil ].
	self assert: restoredNodeController class identicalTo: OPTestEntityController.
	self assert: restoredNodeController model identicalTo: nodeModel1.
	self assert: restoredEdgeController class identicalTo: OPTestRelationController.
	self assert: restoredEdgeController model identicalTo: edgeModel
]

{ #category : 'tests' }
OPDiagramExplorerTest >> testHideMultipleElementsInSingleTransaction [

	| restoredNode1 restoredNode2 restoredEdge |
	self assert: diagramController controllers size equals: 3.
	explorer hideElements: {
			nodeModel1.
			nodeModel2 }.
	self assertEmpty: diagramController controllers.
	undoManager undo.
	self assert: diagramController controllers size equals: 3.
	restoredNode1 := diagramController controllerForModel: nodeModel1 ifNone: [ nil ].
	restoredNode2 := diagramController controllerForModel: nodeModel2 ifNone: [ nil ].
	restoredEdge := diagramController controllerForModel: edgeModel ifNone: [ nil ].
	self assert: restoredNode1 class identicalTo: OPTestEntityController.
	self assert: restoredNode1 model identicalTo: nodeModel1.
	self assert: restoredNode2 class identicalTo: OPTestEntityController.
	self assert: restoredNode2 model identicalTo: nodeModel2.
	self assert: restoredEdge class identicalTo: OPTestRelationController.
	self assert: restoredEdge model identicalTo: edgeModel.
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

	| hiddenNode shownController |
	hiddenNode := OPTestEntityModel new.
	hiddenNode instVarNamed: #uuid put: UUID new.
	containerModel add: hiddenNode.
	self assert: (diagramController controllerForModel: hiddenNode ifNone: [ nil ]) identicalTo: nil.
	explorer showElement: hiddenNode.
	shownController := diagramController controllerForModel: hiddenNode ifNone: [ nil ].
	self assert: shownController class identicalTo: OPTestEntityController.
	self assert: shownController model identicalTo: hiddenNode.
	undoManager undo.
	self assert: (diagramController controllerForModel: hiddenNode ifNone: [ nil ]) identicalTo: nil
]

{ #category : 'accessing' }
OPDiagramExplorerTest >> undoManager [ ^ undoManager
]
