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
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
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
	diagramController canvasPresenter: (OPCanvasPresenter new canvas: RSCanvas new; yourself)
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

	self assert: (diagram ownedElements includes: noteElement).
	self assert: (canvas shapes anySatisfy: [ :s | s model == noteElement ]).

	undoManager undo.
	self deny: (diagram ownedElements includes: noteElement).
	self assert: (canvas shapes noneSatisfy: [ :s | s model == noteElement ]).

	undoManager redo.
	self assert: (diagram ownedElements includes: noteElement).
	self assert: (canvas shapes anySatisfy: [ :s | s model == noteElement ]).
	self assert: command diagramElement == noteElement
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
	self deny: (diagramController viewModelRegistry hasViewModelFor: edgeModel).
	self assert: (nodeCmd diagramElement sourceEdges noneSatisfy: [ :e | e == edgeElement ]).
	self assert: (nodeCmd diagramElement targetEdges noneSatisfy: [ :e | e == edgeElement ]).

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

	self assert: (diagram ownedElements includes: edgeElement).

	"Simulate closing the diagram: remove its visual rendering"
	diagram removeRender.
	self deny: diagram isRendered.

	"Undo edge in closed diagram: detaches from domain and diagram model without GUI errors"
	undoManager undo.
	self deny: (diagram ownedElements includes: edgeElement).
	self deny: (diagramController viewModelRegistry hasViewModelFor: edgeModel).

	"Redo edge in closed diagram: reconnects domain and diagram model without GUI errors"
	undoManager redo.
	self assert: (diagram ownedElements includes: edgeElement).
	self assert: (diagramController viewModelRegistry hasViewModelFor: edgeModel).
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

	self assert: (diagram ownedElements includes: edgeElement).
	self assert: edgeElement source identicalTo: sourceCmd diagramElement.
	self assert: edgeElement target identicalTo: targetCmd diagramElement.

	undoManager undo.
	self deny: (diagram ownedElements includes: edgeElement).
	self deny: (diagramController viewModelRegistry hasViewModelFor: edgeModel).

	undoManager redo.
	self assert: (diagram ownedElements includes: edgeElement).
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

	self assert: createdModel isNotNil.
	self assert: (diagram ownedElements includes: createdEdge).
	self assert: createdEdge source identicalTo: sourceCmd diagramElement.
	self assert: createdEdge target identicalTo: targetCmd diagramElement.
	self assert: undoManager canUndo.

	"Undo edge creation via palette tool"
	undoManager undo.
	self deny: (diagram ownedElements includes: createdEdge).
	self deny: (diagramController viewModelRegistry hasViewModelFor: createdModel).

	"Redo edge creation"
	undoManager redo.
	self assert: (diagram ownedElements includes: createdEdge).
	self assert: (diagramController viewModelRegistry hasViewModelFor: createdModel).
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
	self assert: (diagramController controllers noneSatisfy: [ :c | c model == nodeModel ]).
	self assert: (canvas shapes noneSatisfy: [ :s | s model == diagramElement ]).

	undoManager redo.
	self assert: (diagramController controllers count: [ :c | c model == nodeModel ]) equals: 1.
	self assert: (canvas shapes count: [ :s | s model == diagramElement ]) equals: 1.

	"Cycle 2"
	undoManager undo.
	self assert: (diagramController controllers noneSatisfy: [ :c | c model == nodeModel ]).
	self assert: (canvas shapes noneSatisfy: [ :s | s model == diagramElement ]).

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

	self assert: (containerModel entities includes: nodeModel).
	self assert: (diagram ownedElements includes: de).

	"Simulate closing the diagram: remove its visual rendering"
	diagram removeRender.
	self deny: diagram isRendered.

	"Undo while diagram is closed: removes from domain and diagram model without GUI errors"
	undoManager undo.
	self deny: (containerModel entities includes: nodeModel).
	self deny: (diagram ownedElements includes: de).

	"Redo while diagram is closed: restores domain and diagram model without GUI errors"
	undoManager redo.
	self assert: (containerModel entities includes: nodeModel).
	self assert: (diagram ownedElements includes: de).
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

	self assert: (containerModel entities includes: nodeModel).
	self assert: (diagramController viewModelRegistry hasViewModelFor: nodeModel).
	self assert: (diagram ownedElements includes: diagramElement).
	self assert: diagramElement bounds position equals: initialPosition.

	"2. Undo creation - removes from container, registry, and diagram"
	undoManager undo.
	self deny: (containerModel entities includes: nodeModel).
	self deny: (diagramController viewModelRegistry hasViewModelFor: nodeModel).
	self deny: (diagram ownedElements includes: diagramElement).

	"3. Redo creation - restores exact instances with identical identity"
	undoManager redo.
	self assert: (containerModel entities includes: nodeModel).
	self assert: (diagramController viewModelRegistry viewModelFor: nodeModel) identicalTo: nodeViewModel.
	self assert: (diagram ownedElements includes: diagramElement).
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

	self assert: createdModel isNotNil.
	self assert: (containerModel entities includes: createdModel).
	self assert: undoManager canUndo.

	undoManager undo.
	self deny: (containerModel entities includes: createdModel).
	self deny: (diagramController viewModelRegistry hasViewModelFor: createdModel).

	undoManager redo.
	self assert: (containerModel entities includes: createdModel).
	self assert: (diagramController viewModelRegistry hasViewModelFor: createdModel)
]
