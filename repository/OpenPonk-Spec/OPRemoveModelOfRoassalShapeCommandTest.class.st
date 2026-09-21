Class {
	#name : 'OPRemoveModelOfRoassalShapeCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'project',
		'container',
		'nodeA',
		'nodeB',
		'diagramController',
		'undoManager',
		'command'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPRemoveModelOfRoassalShapeCommandTest >> setUp [
	| diagram controllerA controllerB projectController testCanvas |
	super setUp.
	project := OPProject new.
	container := OPTestContainerModel new.
	container instVarNamed: #uuid put: UUID new.
	nodeA := OPTestEntityModel new.
	nodeA instVarNamed: #uuid put: UUID new.
	nodeB := OPTestEntityModel new.
	nodeB instVarNamed: #uuid put: UUID new.
	container add: nodeA.
	container add: nodeB.
	project addModel: container.

	testCanvas := RSCanvas new.
	diagram := OPOpenPonkDiagram forModelElement: container.
	diagram canvas: testCanvas.
	project addDiagram: diagram.

	undoManager := OPUndoManager new.
	projectController := OPProjectController forProject: project.
	projectController instVarNamed: #undoManager put: undoManager.

	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController model: container; diagramElement: diagram.
	diagramController canvasPresenter: (OPCanvasPresenter new canvas: testCanvas; yourself).

	controllerA := diagramController showInDiagramModel: nodeA.
	controllerB := diagramController showInDiagramModel: nodeB.

	command := OPRemoveModelOfRoassalShapeCommand new.
	command instVarNamed: #diagramController put: diagramController.
	command instVarNamed: #canvas put: diagramController canvas.
	command instVarNamed: #roassalShapes put: { controllerA roassalShape . controllerB roassalShape }.
	command instVarNamed: #controllers put: { controllerA . controllerB }.
	command instVarNamed: #models put: { nodeA . nodeB }
]

{ #category : 'running' }
OPRemoveModelOfRoassalShapeCommandTest >> tearDown [
	command := nil.
	diagramController := nil.
	undoManager := nil.
	project := nil.
	container := nil.
	nodeA := nil.
	nodeB := nil.
	super tearDown
]

{ #category : 'tests' }
OPRemoveModelOfRoassalShapeCommandTest >> testCanvasShortcutActivationIsDelete [
	| activation |
	activation := OPRemoveModelOfRoassalShapeCommand canvasShortcutActivation.
	self assert: activation keyCombination equals: KeyboardKey delete asKeyCombination
]

{ #category : 'tests' }
OPRemoveModelOfRoassalShapeCommandTest >> testExecuteDoesNotOpenDialogAndIsAtomic [
	self assert: container entities size equals: 2.
	command execute.
	self assert: container entities isEmpty.
	self assert: (undoManager instVarNamed: #undoStack) size equals: 1.
	undoManager undo.
	self assert: container entities size equals: 2.
	self assert: diagramController controllers size equals: 2
]

{ #category : 'tests' }
OPRemoveModelOfRoassalShapeCommandTest >> testExecuteWithoutConfirmationIsAtomic [
	self assert: container entities size equals: 2.
	command executeWithoutConfirmation.
	self assert: container entities isEmpty.
	self assert: (undoManager instVarNamed: #undoStack) size equals: 1.
	undoManager undo.
	self assert: container entities size equals: 2.
	self assert: diagramController controllers size equals: 2
]
