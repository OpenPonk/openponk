Class {
	#name : 'OPDiagramFigureColorCommandTest',
	#superclass : 'TestCase',
	#instVars : [
		'project',
		'package',
		'diagram',
		'diagramController',
		'undoManager',
		'classController'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPDiagramFigureColorCommandTest >> setUp [
	| projectController |
	super setUp.
	project := OPProject new.
	package := OPNote new.
	project addDiagram: (OPOpenPonkDiagram new).
	diagram := project diagrams first.
	projectController := OPProjectController new.
	projectController project: project.
	undoManager := OPUndoManager new.
	projectController instVarNamed: #undoManager put: undoManager.
	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController
		workbenchAnnouncer: Announcer new;
		diagramElement: diagram;
		canvasPresenter: (OPCanvasPresenter new canvas: RSCanvas new; yourself).
	classController := OPNoteController new.
	diagramController addAsTargetFor: classController.
	(undoManager instVarNamed: #undoStack) removeAll
]

{ #category : 'running' }
OPDiagramFigureColorCommandTest >> tearDown [
	classController := nil.
	undoManager := nil.
	diagramController := nil.
	diagram := nil.
	package := nil.
	project := nil.
	super tearDown
]

{ #category : 'tests' }
OPDiagramFigureColorCommandTest >> testMagentaFillColorCommandIsUndoable [
	| shape initialColor command toolContext targetColor |
	shape := classController roassalShape.
	initialColor := classController diagramElement fillColor.
	targetColor := OPDiagramFigureMagentaFillColorCommand color.

	command := OPDiagramFigureMagentaFillColorCommand new.
	toolContext := OPRoassalShapeContext
		for: diagramController canvasPresenter
		of: { shape }.
	command readParametersFromContext: toolContext.
	command execute.

	self assert: classController diagramElement fillColor equals: targetColor.
	self deny: (undoManager instVarNamed: #undoStack) isEmpty.

	undoManager undo.
	self assert: classController diagramElement fillColor equals: initialColor.

	undoManager redo.
	self assert: classController diagramElement fillColor equals: targetColor
]
