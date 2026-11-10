"
Tests transactional color modification commands for diagram shapes and verifies undo/redo reversibility.
"
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
OPDiagramFigureColorCommandTest >> testDefaultFillColorCommandRemovesLocalStylePropertyAndIsUndoable [
	| shape element coloredCommand defaultCommand toolContext |
	element := classController diagramElement.
	shape := classController roassalShape.
	toolContext := OPRoassalShapeContext for: diagramController canvasPresenter of: { shape }.
	coloredCommand := OPDiagramFigureMagentaFillColorCommand new.
	coloredCommand readParametersFromContext: toolContext.
	coloredCommand execute.
	self
		assert: (element localStyle includesKey: #fillColor)
		description: 'Magenta fill color command should store #fillColor in localStyle'.
	self assert: element fillColor equals: OPDiagramFigureMagentaFillColorCommand color.
	defaultCommand := OPDiagramFigureDefaultFillColorCommand new.
	defaultCommand readParametersFromContext: toolContext.
	defaultCommand execute.
	self
		deny: (element localStyle includesKey: #fillColor)
		description: 'Default fill color command should remove #fillColor from localStyle'.
	undoManager undo.
	self
		assert: (element localStyle includesKey: #fillColor)
		description: 'Undoing default fill color command should restore #fillColor in localStyle'.
	self assert: element fillColor equals: OPDiagramFigureMagentaFillColorCommand color.
	undoManager redo.
	self
		deny: (element localStyle includesKey: #fillColor)
		description: 'Redoing default fill color command should remove #fillColor from localStyle again'
]

{ #category : 'tests' }
OPDiagramFigureColorCommandTest >> testMagentaFillColorCommandIsUndoable [

	| shape initialColor command toolContext targetColor |
	shape := classController roassalShape.
	initialColor := classController diagramElement fillColor.
	targetColor := OPDiagramFigureMagentaFillColorCommand color.

	command := OPDiagramFigureMagentaFillColorCommand new.
	toolContext := OPRoassalShapeContext for: diagramController canvasPresenter of: { shape }.
	command readParametersFromContext: toolContext.
	command execute.

	self assert: classController diagramElement fillColor equals: targetColor.
	self denyEmpty: (undoManager instVarNamed: #undoStack).

	undoManager undo.
	self assert: classController diagramElement fillColor equals: initialColor.

	undoManager redo.
	self assert: classController diagramElement fillColor equals: targetColor
]
