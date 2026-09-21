"
I verify that element bounds are faithfully restored on undo without being overridden by canvas click position.
"
Class {
	#name : 'OPNodePositionUndoTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPNodePositionUndoTest >> testUndoRestoresOriginalBoundsEvenIfCanvasClicked [
	| project containerModel testCanvas diagramElement undoManager projectController diagramController initialBounds removeCommand createCommand |
	project := OPProject new.
	containerModel := OPTestContainerModel new.
	containerModel instVarNamed: #uuid put: UUID new.
	project addModel: containerModel.

	testCanvas := RSCanvas new.
	diagramElement := OPOpenPonkDiagram forModelElement: containerModel.
	diagramElement canvas: testCanvas.

	undoManager := OPUndoManager new.
	projectController := OPProjectController forProject: project.
	projectController instVarNamed: #undoManager put: undoManager.

	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController model: containerModel.
	diagramController diagramElement: diagramElement.
	diagramController canvasPresenter: (OPCanvasPresenter new canvas: testCanvas; yourself).

	createCommand := OPCreateNodeCommand
		controllerClass: OPTestEntityController
		parentModel: containerModel
		diagramController: diagramController
		position: 100 @ 100.
	undoManager inTransaction: [ undoManager execute: createCommand ].

	initialBounds := (diagramController controllerForModel: createCommand model) diagramElement bounds copy.
	self assert: initialBounds position equals: 100 @ 100.

	removeCommand := OPRemoveModelElementCommand
		model: createCommand model
		projectController: projectController.
	undoManager execute: removeCommand.

	diagramController canvasPresenter selectedShapes: #() onPosition: 300 @ 300.

	undoManager undo.

	self
		assert: (diagramController controllerForModel: createCommand model) diagramElement bounds position
		equals: 100 @ 100
]
