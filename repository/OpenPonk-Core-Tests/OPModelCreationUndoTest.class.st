"
Verifies that model element creation commands can be completely reversed and restored via the project undo manager.
"
Class {
	#name : 'OPModelCreationUndoTest',
	#superclass : 'TestCase',
	#instVars : [
		'project',
		'containerModel',
		'diagram',
		'diagramController',
		'undoManager'
	],
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
}

{ #category : 'running' }
OPModelCreationUndoTest >> setUp [
	| projectController |
	super setUp.
	project := OPProject new.
	containerModel := OPTestContainerModel new.
	project addModel: containerModel.

	diagram := OPOpenPonkDiagram forModelElement: containerModel.
	project addDiagram: diagram.

	undoManager := OPUndoManager new.
	projectController := OPProjectController new.
	projectController project: project.
	projectController instVarNamed: #undoManager put: undoManager.

	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController model: containerModel.
	diagramController diagramElement: diagram.
	diagramController canvasPresenter: (OPHeadlessCanvasPresenter new canvas: RSCanvas new; yourself)
]

{ #category : 'tests' }
OPModelCreationUndoTest >> testCreateDiagramOnlyElementUndoRedo [

	| command noteElement canvas |
	canvas := diagramController canvasPresenter canvas.
	command := OPCreateNodeCommand
		           controllerClass: OPNoteController
		           parentModel: containerModel
		           diagramController: diagramController
		           position: 200 @ 150.

	undoManager inTransaction: [ undoManager execute: command ].
	noteElement := command diagramElement.
	self assertCollection: diagram ownedElements includesAll: { noteElement }.
	self
		assert: (canvas shapes anySatisfy: [ :s | s model == noteElement ])
		description: 'Canvas should contain a shape for the created note element'.

	undoManager undo.
	self denyCollection: diagram ownedElements includesAny: { noteElement }.
	self
		 assert: (canvas shapes noneSatisfy: [ :s | s model == noteElement ])
		 description: 'Canvas should not contain any shape for the note element after undo'.

	undoManager redo.
	self assertCollection: diagram ownedElements includesAll: { noteElement }.
	self
		assert: (canvas shapes anySatisfy: [ :s | s model == noteElement ])
		description: 'Canvas should contain a shape for the note element after redo'.
	self assert: command diagramElement identicalTo: noteElement
]

{ #category : 'tests' }
OPModelCreationUndoTest >> testCreateEdgeSelfLoopUndoRedo [

	| nodeCmd node edgeCmd edgeModel edgeElement |
	nodeCmd := OPCreateNodeCommand
		           controllerClass: OPTestEntityController
		           parentModel: containerModel
		           diagramController: diagramController
		           position: 100 @ 100.
	undoManager inTransaction: [ undoManager execute: nodeCmd ].
	node := nodeCmd model.

	edgeCmd := OPCreateEdgeCommand
		           controllerClass: OPTestRelationController
		           source: (diagramController controllerForModel: node)
		           target: (diagramController controllerForModel: node)
		           parentModel: containerModel
		           diagramController: diagramController.

	undoManager inTransaction: [ undoManager execute: edgeCmd ].
	edgeModel := edgeCmd model.
	edgeElement := edgeCmd diagramElement.
	self assert: edgeElement source identicalTo: nodeCmd diagramElement.
	self assert: edgeElement target identicalTo: nodeCmd diagramElement.
	self assertCollection: diagram ownedElements includesAll: { edgeElement }.

	undoManager undo.
	self denyCollection: diagram ownedElements includesAny: { edgeElement }.
	self
		deny: (diagramController viewModelRegistry hasViewModelFor: edgeModel)
		description: 'Edge view model should be unregistered after undo'.
	self denyCollection: nodeCmd diagramElement sourceEdges includesAny: { edgeElement }.
	self denyCollection: nodeCmd diagramElement targetEdges includesAny: { edgeElement }.

	undoManager redo.
	self assertCollection: diagram ownedElements includesAll: { edgeElement }.
	self assert: edgeElement source identicalTo: nodeCmd diagramElement.
	self assert: edgeElement target identicalTo: nodeCmd diagramElement
]

{ #category : 'tests' }
OPModelCreationUndoTest >> testCreateEdgeUndoRedoInClosedDiagram [

	| sourceCmd targetCmd sourceNode targetNode edgeCmd edgeModel edgeElement |
	sourceCmd := OPCreateNodeCommand
		             controllerClass: OPTestEntityController
		             parentModel: containerModel
		             diagramController: diagramController
		             position: 30 @ 40.
	targetCmd := OPCreateNodeCommand
		             controllerClass: OPTestEntityController
		             parentModel: containerModel
		             diagramController: diagramController
		             position: 180 @ 40.
	undoManager inTransaction: [
			undoManager execute: sourceCmd.
			undoManager execute: targetCmd ].

	sourceNode := sourceCmd model.
	targetNode := targetCmd model.

	edgeCmd := OPCreateEdgeCommand
		           controller: OPTestRelationController new
		           source: (diagramController controllerForModel: sourceNode)
		           target: (diagramController controllerForModel: targetNode)
		           parentModel: containerModel
		           diagramController: diagramController.

	undoManager inTransaction: [ undoManager execute: edgeCmd ].
	edgeModel := edgeCmd model.
	edgeElement := edgeCmd diagramElement.
	self assertCollection: diagram ownedElements includesAll: { edgeElement }.

	"Simulate closing the diagram: remove its visual rendering"
	diagram removeRender.
	self
		deny: diagram isRendered
		description: 'Diagram should not be rendered after removeRender'.

	"Undo edge in closed diagram: detaches from domain and diagram model without GUI errors"
	undoManager undo.
	self denyCollection: diagram ownedElements includesAny: { edgeElement }.
	self
		deny: (diagramController viewModelRegistry hasViewModelFor: edgeModel)
		description: 'Edge view model should be unregistered after undo in closed diagram'.

	"Redo edge in closed diagram: reconnects domain and diagram model without GUI errors"
	undoManager redo.
	self assertCollection: diagram ownedElements includesAll: { edgeElement }.
	self
		assert: (diagramController viewModelRegistry hasViewModelFor: edgeModel)
		description: 'Edge view model should be registered after redo in closed diagram'.
	self assert: edgeElement source identicalTo: sourceCmd diagramElement.
	self assert: edgeElement target identicalTo: targetCmd diagramElement
]

{ #category : 'tests' }
OPModelCreationUndoTest >> testCreateEdgeUndoRedoPreservesIdentity [

	| sourceCmd targetCmd sourceNode targetNode edgeCmd edgeModel edgeElement |
	sourceCmd := OPCreateNodeCommand
		             controllerClass: OPTestEntityController
		             parentModel: containerModel
		             diagramController: diagramController
		             position: 50 @ 50.
	targetCmd := OPCreateNodeCommand
		             controllerClass: OPTestEntityController
		             parentModel: containerModel
		             diagramController: diagramController
		             position: 250 @ 50.
	undoManager inTransaction: [
			undoManager execute: sourceCmd.
			undoManager execute: targetCmd ].

	sourceNode := sourceCmd model.
	targetNode := targetCmd model.

	edgeCmd := OPCreateEdgeCommand
		           controllerClass: OPTestRelationController
		           source: (diagramController controllerForModel: sourceNode)
		           target: (diagramController controllerForModel: targetNode)
		           parentModel: containerModel
		           diagramController: diagramController.

	undoManager inTransaction: [ undoManager execute: edgeCmd ].

	edgeModel := edgeCmd model.
	edgeElement := edgeCmd diagramElement.
	self assertCollection: diagram ownedElements includesAll: { edgeElement }.
	self assert: edgeElement source identicalTo: sourceCmd diagramElement.
	self assert: edgeElement target identicalTo: targetCmd diagramElement.

	undoManager undo.
	self denyCollection: diagram ownedElements includesAny: { edgeElement }.
	self
		deny: (diagramController viewModelRegistry hasViewModelFor: edgeModel)
		description: 'Edge view model should be unregistered after undo'.

	undoManager redo.
	self assertCollection: diagram ownedElements includesAll: { edgeElement }.
	self assert: edgeCmd model identicalTo: edgeModel.
	self assert: edgeCmd diagramElement identicalTo: edgeElement.
	self assert: edgeElement source identicalTo: sourceCmd diagramElement.
	self assert: edgeElement target identicalTo: targetCmd diagramElement
]

{ #category : 'tests' }
OPModelCreationUndoTest >> testCreateEdgeViaAddAsTargetExecutesThroughUndoManager [

	| sourceCmd targetCmd sourceNode targetNode relationController createdModel createdEdge |
	sourceCmd := OPCreateNodeCommand
		             controllerClass: OPTestEntityController
		             parentModel: containerModel
		             diagramController: diagramController
		             position: 50 @ 50.
	targetCmd := OPCreateNodeCommand
		             controllerClass: OPTestEntityController
		             parentModel: containerModel
		             diagramController: diagramController
		             position: 200 @ 50.
	undoManager inTransaction: [
			undoManager execute: sourceCmd.
			undoManager execute: targetCmd ].

	sourceNode := sourceCmd model.
	targetNode := targetCmd model.

	relationController := OPTestRelationController new.
	(diagramController controllerForModel: sourceNode) addAsSourceFor: relationController.
	(diagramController controllerForModel: targetNode) addAsTargetFor: relationController.

	createdModel := relationController model.
	createdEdge := relationController diagramElement.

	self deny: createdModel identicalTo: nil.
	self assertCollection: diagram ownedElements includesAll: { createdEdge }.
	self assert: createdEdge source identicalTo: sourceCmd diagramElement.
	self assert: createdEdge target identicalTo: targetCmd diagramElement.
	self
		assert: undoManager canUndo
		description: 'Undo manager should have an undoable transaction after edge creation'.

	"Undo edge creation via palette tool"
	undoManager undo.
	self denyCollection: diagram ownedElements includesAny: { createdEdge }.
	self
		deny: (diagramController viewModelRegistry hasViewModelFor: createdModel)
		description: 'Created edge view model should be unregistered after undo'.

	"Redo edge creation"
	undoManager redo.
	self assertCollection: diagram ownedElements includesAll: { createdEdge }.
	self
		assert: (diagramController viewModelRegistry hasViewModelFor: createdModel)
		description: 'Created edge view model should be registered after redo'.
	self assert: createdEdge source identicalTo: sourceCmd diagramElement.
	self assert: createdEdge target identicalTo: targetCmd diagramElement
]

{ #category : 'tests' }
OPModelCreationUndoTest >> testCreateNodeMultipleUndoRedoCycles [

	| command nodeModel diagramElement canvas |
	canvas := diagramController canvasPresenter canvas.
	command := OPCreateNodeCommand
		           controllerClass: OPTestEntityController
		           parentModel: containerModel
		           diagramController: diagramController
		           position: 70 @ 90.

	undoManager inTransaction: [ undoManager execute: command ].
	nodeModel := command model.
	diagramElement := command diagramElement.

	self assert: (diagramController controllers count: [ :c | c model == nodeModel ]) equals: 1.
	self assert: (canvas shapes count: [ :s | s model == diagramElement ]) equals: 1.

	"Cycle 1"
	undoManager undo.
	self assert: (diagramController controllers count: [ :c | c model == nodeModel ]) equals: 0.
	self assert: (canvas shapes count: [ :s | s model == diagramElement ]) equals: 0.

	undoManager redo.
	self assert: (diagramController controllers count: [ :c | c model == nodeModel ]) equals: 1.
	self assert: (canvas shapes count: [ :s | s model == diagramElement ]) equals: 1.

	"Cycle 2"
	undoManager undo.
	self assert: (diagramController controllers count: [ :c | c model == nodeModel ]) equals: 0.
	self assert: (canvas shapes count: [ :s | s model == diagramElement ]) equals: 0.

	undoManager redo.
	self assert: (diagramController controllers count: [ :c | c model == nodeModel ]) equals: 1.
	self assert: (canvas shapes count: [ :s | s model == diagramElement ]) equals: 1.
	self assert: diagramElement bounds position equals: 70 @ 90
]

{ #category : 'tests' }
OPModelCreationUndoTest >> testCreateNodeUndoRedoInClosedDiagram [

	| command nodeModel nodeViewModel de initialPosition |
	initialPosition := 100 @ 100.

	command := OPCreateNodeCommand
		           controllerClass: OPTestEntityController
		           parentModel: containerModel
		           diagramController: diagramController
		           position: initialPosition.

	undoManager inTransaction: [ undoManager execute: command ].
	nodeModel := command model.
	nodeViewModel := command viewModel.
	de := command diagramElement.
	self assertCollection: containerModel entities includesAll: { nodeModel }.
	self assertCollection: diagram ownedElements includesAll: { de }.

	"Simulate closing the diagram: remove its visual rendering"
	diagram removeRender.
	self
		deny: diagram isRendered
		description: 'Diagram should not be rendered after removeRender'.

	"Undo while diagram is closed: removes from domain and diagram model without GUI errors"
	undoManager undo.
	self denyCollection: containerModel entities includesAny: { nodeModel }.
	self denyCollection: diagram ownedElements includesAny: { de }.

	"Redo while diagram is closed: restores domain and diagram model without GUI errors"
	undoManager redo.
	self assertCollection: containerModel entities includesAll: { nodeModel }.
	self assertCollection: diagram ownedElements includesAll: { de }.
	self assert: de bounds position equals: initialPosition
]

{ #category : 'tests' }
OPModelCreationUndoTest >> testCreateNodeUndoRedoPreservesIdentity [

	| command nodeModel nodeViewModel diagramElement initialPosition |
	initialPosition := 120 @ 80.
	command := OPCreateNodeCommand
		           controllerClass: OPTestEntityController
		           parentModel: containerModel
		           diagramController: diagramController
		           position: initialPosition.

	"1. Execute creation"
	undoManager inTransaction: [ undoManager execute: command ].

	nodeModel := command model.
	nodeViewModel := command viewModel.
	diagramElement := command diagramElement.
	self assertCollection: containerModel entities includesAll: { nodeModel }.
	self
		assert: (diagramController viewModelRegistry hasViewModelFor: nodeModel)
		description: 'Node view model should be registered after creation'.
	self assertCollection: diagram ownedElements includesAll: { diagramElement }.
	self assert: diagramElement bounds position equals: initialPosition.

	"2. Undo creation - removes from container, registry, and diagram"
	undoManager undo.
	self denyCollection: containerModel entities includesAny: { nodeModel }.
	self
		deny: (diagramController viewModelRegistry hasViewModelFor: nodeModel)
		description: 'Node view model should be unregistered after undo'.
	self denyCollection: diagram ownedElements includesAny: { diagramElement }.

	"3. Redo creation - restores exact instances with identical identity"
	undoManager redo.
	self assertCollection: containerModel entities includesAll: { nodeModel }.
	self assert: (diagramController viewModelRegistry viewModelFor: nodeModel) identicalTo: nodeViewModel.
	self assertCollection: diagram ownedElements includesAll: { diagramElement }.
	self assert: command model identicalTo: nodeModel.
	self assert: command diagramElement identicalTo: diagramElement.
	self assert: diagramElement bounds position equals: initialPosition
]

{ #category : 'tests' }
OPModelCreationUndoTest >> testCreationViaAddAsTargetExecutesThroughUndoManager [

	| entityController createdModel |
	entityController := OPTestEntityController new.

	"Simulate user drop / click from palette tool"
	diagramController addAsTargetFor: entityController.
	createdModel := entityController model.

	self deny: createdModel identicalTo: nil.
	self assertCollection: containerModel entities includesAll: { createdModel }.
	self
		assert: undoManager canUndo
		description: 'Undo manager should have an undoable transaction after node creation'.

	undoManager undo.
	self denyCollection: containerModel entities includesAny: { createdModel }.
	self
		deny: (diagramController viewModelRegistry hasViewModelFor: createdModel)
		description: 'Node view model should be unregistered after undo'.

	undoManager redo.
	self assertCollection: containerModel entities includesAll: { createdModel }.
	self
		assert: (diagramController viewModelRegistry hasViewModelFor: createdModel)
		description: 'Node view model should be registered after redo'
]
