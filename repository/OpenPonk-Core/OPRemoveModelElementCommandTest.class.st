Class {
	#name : 'OPRemoveModelElementCommandTest',
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
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'running' }
OPRemoveModelElementCommandTest >> setUp [
	| diagramElement projectController |
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

	diagramElement := OPOpenPonkDiagram forModelElement: containerModel.

	undoManager := OPUndoManager new.

	projectController := OPProjectController forProject: activeProject.
	projectController instVarNamed: #undoManager put: undoManager.

	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController model: containerModel.
	diagramController diagramElement: diagramElement.
	diagramController canvasPresenter: (OPCanvasPresenter new canvas: RSCanvas new; yourself).

	diagramController showInDiagramModel: nodeModel1.
	diagramController showInDiagramModel: nodeModel2.
	diagramController showInDiagramModel: edgeModel
]

{ #category : 'running' }
OPRemoveModelElementCommandTest >> tearDown [
	diagramController := nil.
	undoManager := nil.
	activeProject := nil.
	containerModel := nil.
	nodeModel1 := nil.
	nodeModel2 := nil.
	edgeModel := nil.
	super tearDown
]

{ #category : 'tests' }
OPRemoveModelElementCommandTest >> testCaptureDiagramElementsSynchronizesBoundsFromRender [
	| canvas entityModel diagram diagramElement removeCommand capturedDescriptor project projectController |
	canvas := RSCanvas new.
	containerModel := OPTestContainerModel new.
	entityModel := OPTestEntityModel new.
	containerModel add: entityModel.
	project := OPProject named: 'TestHeadless'.
	project addModel: containerModel.
	projectController := OPProjectController forProject: project.
	diagram := OPOpenPonkDiagram forModelElement: containerModel.
	project addDiagram: diagram.

	diagramElement := OPTestBoundNode new.
	diagramElement modelElement: entityModel.
	diagramElement owningElement: diagram.
	diagram ownedElements add: diagramElement.
	diagramElement renderIn: canvas.
	diagramElement roassalShape translateTo: 150 @ 250.

	removeCommand := OPRemoveModelElementCommand
		model: entityModel
		projectController: projectController.

	capturedDescriptor := removeCommand diagramElementDescriptors detect: [ :eachDescriptor |
		eachDescriptor diagramElement == diagramElement ].

	self assert: capturedDescriptor bounds isNotNil.
	self assert: (capturedDescriptor bounds isKindOf: OPNodeBounds).
	self assert: capturedDescriptor bounds position equals: 150 @ 250
]

{ #category : 'tests' }
OPRemoveModelElementCommandTest >> testCascadeRemovalAndUndoRedoMultiDiagramWithEdgeAndWaypoints [
	| project container nodeA nodeB edge diagram1 diagram2 controller1 controller2 manager command nodeElement1 nodeElement2 edgeElement1 edgeElement2 initialWaypoints projectController |
	project := OPProject new.
	container := OPTestContainerModel new.
	container instVarNamed: #uuid put: UUID new.
	nodeA := OPTestEntityModel new.
	nodeA instVarNamed: #uuid put: UUID new.
	nodeB := OPTestEntityModel new.
	nodeB instVarNamed: #uuid put: UUID new.
	edge := OPTestRelationModel new.
	edge instVarNamed: #uuid put: UUID new.
	edge source: nodeA.
	edge target: nodeB.
	container add: nodeA.
	container add: nodeB.
	container add: edge.
	project addModel: container.

	diagram1 := OPOpenPonkDiagram forModelElement: container.
	diagram2 := OPOpenPonkDiagram forModelElement: container.
	project addDiagram: diagram1.
	project addDiagram: diagram2.

	manager := OPUndoManager new.
	projectController := OPProjectController forProject: project.
	projectController instVarNamed: #undoManager put: manager.

	controller1 := OPTestDiagramController new.
	projectController addDiagramController: controller1.
	controller1 model: container; diagramElement: diagram1.
	controller1 canvasPresenter: (OPCanvasPresenter new canvas: RSCanvas new; yourself).

	controller2 := OPTestDiagramController new.
	projectController addDiagramController: controller2.
	controller2 model: container; diagramElement: diagram2.
	controller2 canvasPresenter: (OPCanvasPresenter new canvas: RSCanvas new; yourself).

	controller1 showInDiagramModel: nodeA; showInDiagramModel: nodeB; showInDiagramModel: edge.
	controller2 showInDiagramModel: nodeA; showInDiagramModel: nodeB; showInDiagramModel: edge.

	nodeElement1 := (controller1 controllerForModel: nodeA) diagramElement.
	nodeElement2 := (controller2 controllerForModel: nodeA) diagramElement.
	nodeElement1 bounds: (OPNodeBounds withPosition: 100 @ 100 extent: 50 @ 50).
	nodeElement2 bounds: (OPNodeBounds withPosition: 300 @ 300 extent: 80 @ 80).

	initialWaypoints := { 10 @ 10 . 50 @ 50 . 100 @ 100 }.
	edgeElement1 := (controller1 controllerForModel: edge) diagramElement.
	edgeElement2 := (controller2 controllerForModel: edge) diagramElement.
	edgeElement1 waypoints: initialWaypoints copy.
	edgeElement2 waypoints: initialWaypoints copy.

	command := OPRemoveModelElementCommand
		model: nodeA
		projectController: projectController.
	manager inTransaction: [ manager execute: command ].

	self assert: controller1 controllers size equals: 1.
	self assert: controller2 controllers size equals: 1.
	self assert: container entities size equals: 1.

	manager undo.

	self assert: controller1 controllers size equals: 3.
	self assert: controller2 controllers size equals: 3.
	self assert: container entities size equals: 3.
	self assert: (controller1 controllerForModel: nodeA) diagramElement bounds position equals: 100 @ 100.
	self assert: (controller2 controllerForModel: nodeA) diagramElement bounds position equals: 300 @ 300.
	self assert: (controller1 controllerForModel: edge) diagramElement waypoints equals: initialWaypoints.
	self assert: (controller2 controllerForModel: edge) diagramElement waypoints equals: initialWaypoints.
	self assert: (controller1 controllerForModel: edge) diagramElement source equals: nodeElement1.
	self assert: (nodeElement1 sourceEdges includes: (controller1 controllerForModel: edge) diagramElement).

	manager redo.

	self assert: controller1 controllers size equals: 1.
	self assert: controller2 controllers size equals: 1.
	self assert: container entities size equals: 1
]

{ #category : 'tests' }
OPRemoveModelElementCommandTest >> testCascadeRemovalAndUndoRedoWithoutDiagramInProject [
	| removeCommand |
	self assert: diagramController controllers size equals: 3.
	self assert: containerModel entities size equals: 3.

	removeCommand := OPRemoveModelElementCommand
		model: nodeModel1
		diagramController: diagramController.
	undoManager inTransaction: [ undoManager execute: removeCommand ].

	self assert: diagramController controllers size equals: 1.
	self assert: containerModel entities size equals: 1.
	self deny: (containerModel entities includes: nodeModel1).
	self deny: (containerModel entities includes: edgeModel).

	undoManager undo.
	self assert: diagramController controllers size equals: 3.
	self assert: containerModel entities size equals: 3.
	self assert: (containerModel entities includes: nodeModel1).
	self assert: (containerModel entities includes: edgeModel).

	undoManager redo.
	self assert: diagramController controllers size equals: 1.
	self assert: containerModel entities size equals: 1.
	self deny: (containerModel entities includes: nodeModel1).
	self deny: (containerModel entities includes: edgeModel)
]

{ #category : 'tests' }
OPRemoveModelElementCommandTest >> testRemoveRootModelWithoutOwnerSucceedsAndRestoresOnUndo [
	| rootModel project projectController removeCommand |
	project := OPProject named: 'RootModelTest'.
	rootModel := OPTestContainerModel new.
	rootModel name: 'RootContainer'.
	project addModel: rootModel.
	projectController := OPProjectController forProject: project.

	self assertCollection: project models hasSameElements: { rootModel }.

	removeCommand := OPRemoveModelElementCommand
		model: rootModel
		projectController: projectController.

	projectController undoManager execute: removeCommand.
	self assertCollection: project models hasSameElements: #( ).

	projectController undoManager undo.
	self assertCollection: project models hasSameElements: { rootModel }.

	projectController undoManager redo.
	self assertCollection: project models hasSameElements: #( )
]
