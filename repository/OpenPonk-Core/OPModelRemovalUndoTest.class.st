Class {
	#name : 'OPModelRemovalUndoTest',
	#superclass : 'TestCase',
	#instVars : [
		'project',
		'projectController',
		'undoManager',
		'containerModel',
		'diagramController',
		'canvas',
		'openDiagram',
		'closedDiagram',
		'node1Model',
		'node2Model',
		'edgeModel'
	],
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'running' }
OPModelRemovalUndoTest >> setUp [
	| presenter |
	super setUp.
	undoManager := OPUndoManager new.
	project := OPProject new.
	containerModel := OPTestContainerModel new.
	project addModel: containerModel.

	projectController := OPProjectController forProject: project.
	projectController instVarNamed: #undoManager put: undoManager.

	openDiagram := OPOpenPonkDiagram forModelElement: containerModel.
	openDiagram name: 'Open Diagram'.
	project addDiagram: openDiagram.

	closedDiagram := OPOpenPonkDiagram forModelElement: containerModel.
	closedDiagram name: 'Closed Diagram'.
	project addDiagram: closedDiagram.

	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController model: containerModel.
	diagramController diagramElement: openDiagram.

	presenter := OPCanvasPresenter new.
	canvas := presenter canvas.
	presenter attachController: diagramController.
	openDiagram canvas: canvas.

	node1Model := OPTestEntityModel new.
	node2Model := OPTestEntityModel new.
	containerModel add: node1Model.
	containerModel add: node2Model.

	edgeModel := OPTestRelationModel new.
	edgeModel source: node1Model; target: node2Model.
	containerModel add: edgeModel.

	diagramController showInDiagramModel: node1Model.
	diagramController showInDiagramModel: node2Model.
	diagramController showInDiagramModel: edgeModel.

	(diagramController controllerForModel: node1Model) diagramElement
		bounds: (OPNodeBounds withPosition: 100 @ 100 extent: 80 @ 50);
		updateRenderFromSelf.
	(diagramController controllerForModel: node2Model) diagramElement
		bounds: (OPNodeBounds withPosition: 300 @ 100 extent: 80 @ 50);
		updateRenderFromSelf.
	(diagramController controllerForModel: edgeModel) diagramElement
		waypoints: { 180 @ 125 . 240 @ 200 . 300 @ 125 };
		updateRenderFromSelf.

	OPTestDiagramElement
		in: closedDiagram
		forModelElement: node1Model
]

{ #category : 'running' }
OPModelRemovalUndoTest >> tearDown [
	diagramController ifNotNil: [ diagramController removeAllControllers ].
	canvas ifNotNil: [ canvas shapes copy do: #remove ].
	project := nil.
	projectController := nil.
	undoManager := nil.
	super tearDown
]

{ #category : 'tests' }
OPModelRemovalUndoTest >> testNoAllInstancesUsage [
	"Verify architectural cleanliness: command must never scan VM memory for controllers"
	| commandClass forbiddenSelectors |
	commandClass := OPRemoveModelElementCommand.
	forbiddenSelectors := #( #allInstances #allSubInstances ).
	
	commandClass methods do: [ :method |
		forbiddenSelectors do: [ :forbidden |
			self
				deny: (method sendsSelector: forbidden)
				description: ('Method {1}>>#{2} uses forbidden selector #{3}'
					format: { commandClass name . method selector . forbidden }) ] ]
]

{ #category : 'tests' }
OPModelRemovalUndoTest >> testRemoveEdgeOnlyPreservesNodes [

	| edgeShape |
	edgeShape := (diagramController controllerForModel: edgeModel) diagramElement roassalShape.

	diagramController removeModelOfRoassalShape: edgeShape.

	self deny: (containerModel entities includes: edgeModel).
	self assert: (containerModel entities includes: node1Model).
	self assert: (containerModel entities includes: node2Model).
	self deny: (diagramController hasControllerForModel: edgeModel).
	self assert: (diagramController hasControllerForModel: node1Model).
	self assert: (diagramController hasControllerForModel: node2Model).

	self assert: undoManager canUndo.
	undoManager undo.

	self assert: (containerModel entities includes: edgeModel).
	self assert: edgeModel source identicalTo: node1Model.
	self assert: edgeModel target identicalTo: node2Model.
	self assert: (diagramController hasControllerForModel: edgeModel).
	self assert: (diagramController controllerForModel: edgeModel) diagramElement waypoints equals: {
			(180 @ 125).
			(240 @ 200).
			(300 @ 125) }
]

{ #category : 'tests' }
OPModelRemovalUndoTest >> testRemoveModelFromProjectTreeRestoresDiagramElementOnUndo [
	| command |
	command := OPRemoveModelElementCommand
		model: node1Model
		projectController: projectController.

	undoManager inTransaction: [ undoManager execute: command ].

	self deny: (containerModel entities includes: node1Model).
	self deny: (containerModel entities includes: edgeModel).
	self deny: (diagramController hasControllerForModel: node1Model).
	self deny: (diagramController hasControllerForModel: edgeModel).

	undoManager undo.

	self assert: (containerModel entities includes: node1Model).
	self assert: (containerModel entities includes: edgeModel).
	self assert: (diagramController hasControllerForModel: node1Model).
	self assert: (diagramController hasControllerForModel: edgeModel).
	self assert: (diagramController controllerForModel: node1Model) diagramElement bounds position equals: 100 @ 100
]

{ #category : 'tests' }
OPModelRemovalUndoTest >> testRemoveNodeDetachesFromBothOpenAndClosedDiagrams [

	| shapeToClick |
	shapeToClick := (diagramController controllerForModel: node1Model) diagramElement roassalShape.

	"Verify node1 is in closed diagram before removal"
	self assert: (closedDiagram allOwnedElements anySatisfy: [ :each | each modelElements includes: node1Model ]).

	diagramController removeModelOfRoassalShape: shapeToClick.

	"Closed diagram must not contain orphaned diagram element"
	self deny: (closedDiagram allOwnedElements anySatisfy: [ :each | each modelElements includes: node1Model ]).

	undoManager undo.

	"Closed diagram must have diagram element restored"
	self assert: (closedDiagram allOwnedElements anySatisfy: [ :each | each modelElements includes: node1Model ])
]

{ #category : 'tests' }
OPModelRemovalUndoTest >> testRemoveNodeWithCascadeRemovesAndRestoresConnectedEdgeInLifoOrder [

	| shapeToClick node1DiagramElement edgeDiagramElement |
	node1DiagramElement := (diagramController controllerForModel: node1Model) diagramElement.
	edgeDiagramElement := (diagramController controllerForModel: edgeModel) diagramElement.
	shapeToClick := node1DiagramElement roassalShape.

	"Execute removal via diagram controller (simulating UI canvas removal)"
	diagramController removeModelOfRoassalShape: shapeToClick.

	"Verify domain model removal"
	self deny: (containerModel entities includes: node1Model).
	self deny: (containerModel entities includes: edgeModel).
	self assert: (containerModel entities includes: node2Model).

	"Verify visual diagram element removal from open canvas"
	self deny: (diagramController hasControllerForModel: node1Model).
	self deny: (diagramController hasControllerForModel: edgeModel).
	self assert: (diagramController hasControllerForModel: node2Model).

	"Verify undoManager recorded the transaction"
	self assert: undoManager canUndo.

	"Execute UNDO - must restore in LIFO order"
	undoManager undo.

	"Verify domain model restored"
	self assert: (containerModel entities includes: node1Model).
	self assert: (containerModel entities includes: edgeModel).
	self assert: edgeModel source identicalTo: node1Model.
	self assert: edgeModel target identicalTo: node2Model.
	self assert: (diagramController hasControllerForModel: node1Model).
	self assert: (diagramController hasControllerForModel: edgeModel).

	"Verify geometry preservation"
	self assert: (diagramController controllerForModel: node1Model) diagramElement bounds position equals: 100 @ 100.
	self assert: (diagramController controllerForModel: edgeModel) diagramElement waypoints equals: {
			(180 @ 125).
			(240 @ 200).
			(300 @ 125) }.

	"Execute REDO - must cleanly remove again"
	undoManager redo.
	self deny: (containerModel entities includes: node1Model).
	self deny: (containerModel entities includes: edgeModel).
	self deny: (diagramController hasControllerForModel: node1Model).
	self deny: (diagramController hasControllerForModel: edgeModel)
]

{ #category : 'tests' }
OPModelRemovalUndoTest >> testRemoveNodeWithMultipleEdgesRestoresAllInLifoOrder [

	| node3Model edge2Model node2Shape edge1DiagramElement edge2DiagramElement |
	node3Model := OPTestEntityModel new.
	containerModel add: node3Model.
	diagramController showInDiagramModel: node3Model.
	(diagramController controllerForModel: node3Model) diagramElement
		bounds: (OPNodeBounds withPosition: 500 @ 100 extent: 80 @ 50);
		updateRenderFromSelf.

	edge2Model := OPTestRelationModel new.
	edge2Model
		source: node2Model;
		target: node3Model.
	containerModel add: edge2Model.
	diagramController showInDiagramModel: edge2Model.
	(diagramController controllerForModel: edge2Model) diagramElement
		waypoints: {
				(380 @ 125).
				(500 @ 125) };
		updateRenderFromSelf.

	node2Shape := (diagramController controllerForModel: node2Model) diagramElement roassalShape.
	edge1DiagramElement := (diagramController controllerForModel: edgeModel) diagramElement.
	edge2DiagramElement := (diagramController controllerForModel: edge2Model) diagramElement.

	diagramController removeModelOfRoassalShape: node2Shape.

	self deny: (containerModel entities includes: node2Model).
	self deny: (containerModel entities includes: edgeModel).
	self deny: (containerModel entities includes: edge2Model).
	self assert: (containerModel entities includes: node1Model).
	self assert: (containerModel entities includes: node3Model).

	self deny: (diagramController hasControllerForModel: node2Model).
	self deny: (diagramController hasControllerForModel: edgeModel).
	self deny: (diagramController hasControllerForModel: edge2Model).

	undoManager undo.

	self assert: (containerModel entities includes: node2Model).
	self assert: (containerModel entities includes: edgeModel).
	self assert: (containerModel entities includes: edge2Model).
	self assert: edgeModel source identicalTo: node1Model.
	self assert: edgeModel target identicalTo: node2Model.
	self assert: edge2Model source identicalTo: node2Model.
	self assert: edge2Model target identicalTo: node3Model.

	self assert: (diagramController hasControllerForModel: node2Model).
	self assert: (diagramController hasControllerForModel: edgeModel).
	self assert: (diagramController hasControllerForModel: edge2Model).
	self assert: (diagramController controllerForModel: edge2Model) diagramElement waypoints equals: {
			(380 @ 125).
			(500 @ 125) }
]
