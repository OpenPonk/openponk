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
	project addDiagram: OPOpenPonkDiagram new.
	diagram := project diagrams first.
	projectController := OPProjectController forProject: project.
	undoManager := projectController undoManager.
	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController
		workbenchAnnouncer: Announcer new;
		diagramElement: diagram;
		canvasPresenter: (OPCanvasPresenter new canvas: RSCanvas new; yourself).
	classController := OPNoteController new.
	diagramController addAsTargetFor: classController.
	undoManager clear
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
OPDiagramFigureColorCommandTest >> testDefaultStrokeAndFontColorCommandsAndColorMenuGroup [
	| shape element toolContext strokeCmd defaultStrokeCmd defaultFontCmd styleCommand |
	element := classController diagramElement.
	shape := classController roassalShape.
	toolContext := OPRoassalShapeContext for: diagramController canvasPresenter of: { shape }.

	self
		assert: (OPDiagramFigureBlueStrokeColorCommand canBeExecutedInContext: toolContext)
		description: 'Stroke color command should be executable on OPNote'.
	strokeCmd := OPDiagramFigureBlueStrokeColorCommand new.
	strokeCmd readParametersFromContext: toolContext.
	strokeCmd execute.
	self
		assert: (element localStyle includesKey: #strokeColor)
		description: 'Blue stroke color command should set #strokeColor in localStyle'.
	self assert: element strokeColor equals: OPDiagramFigureBlueStrokeColorCommand color.

	defaultStrokeCmd := OPDiagramFigureDefaultStrokeColorCommand new.
	defaultStrokeCmd readParametersFromContext: toolContext.
	self assert: defaultStrokeCmd color isColor description: 'defaultStrokeCmd color should return a Color'.
	defaultStrokeCmd execute.
	self
		deny: (element localStyle includesKey: #strokeColor)
		description: 'Default stroke color command should remove #strokeColor from localStyle'.
	undoManager undo.
	self assert: element strokeColor equals: OPDiagramFigureBlueStrokeColorCommand color.
	undoManager redo.
	self
		deny: (element localStyle includesKey: #strokeColor)
		description: 'Redoing default stroke color command should remove #strokeColor again'.

	self assert: OPDiagramFigureFontColorCommand colorAttribute equals: #fontColor.
	self
		deny: (OPDiagramFigureDefaultFontColorCommand canBeExecutedInContext: toolContext)
		description: 'Font color command must not be executable on element that does not support #fontColor:'.
	defaultFontCmd := OPDiagramFigureDefaultFontColorCommand new.
	defaultFontCmd readParametersFromContext: toolContext.
	self assert: defaultFontCmd color equals: Color transparent.
	styleCommand := defaultFontCmd commandFor: element.
	self assert: styleCommand property equals: #fontColor.
	self
		assert: styleCommand newValue isNil
		description: 'Default font color command should reset #fontColor newValue to nil'.

	self assert: (OPRoassalShapeColorMenuGroup colorNameFor: Color blue) equals: 'Blue'.
	self assert: (OPRoassalShapeColorMenuGroup colorNameFor: (Color fromHexString: 'DCE5EC')) equals: 'Slate'.
	self assert: (OPRoassalShapeColorMenuGroup colorNameFor: (Color fromHexString: 'D6FCEB')) equals: 'Mint'.
	self
		should: [ OPRoassalShapeColorMenuGroup colorNameFor: (Color fromHexString: '123456') ]
		raise: Error
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

{ #category : 'tests' }
OPDiagramFigureColorCommandTest >> testToggleRoassalShapeCommands [
	| container entity1 entity2 relation ctrl1 toolContext hideDepCmd showDepCmd hideCmd |
	[
		OPPluginRegistry setDefaultForTesting.
		container := OPTestContainerModel new.
		container instVarNamed: #uuid put: UUID new.
		entity1 := OPTestEntityModel new name: 'E1'; yourself.
		entity1 instVarNamed: #uuid put: UUID new.
		entity2 := OPTestEntityModel new name: 'E2'; yourself.
		entity2 instVarNamed: #uuid put: UUID new.
		relation := OPTestRelationModel new source: entity1; target: entity2; yourself.
		relation instVarNamed: #uuid put: UUID new.
		container add: entity1; add: entity2; add: relation.
		project addModel: container.
		diagram modelElement: container.
		diagramController model: container.
		ctrl1 := diagramController showInDiagramModel: entity1.
		diagramController showInDiagramModel: entity2.
		diagramController showInDiagramModel: relation.

		toolContext := OPRoassalShapeContext
			for: diagramController canvasPresenter
			of: { ctrl1 roassalShape }.
		self
			assert: (OPHideRoassalShapeCommand canBeExecutedInContext: toolContext)
			description: 'OPHideRoassalShapeCommand should be executable on hideable entity controller'.

		hideDepCmd := OPHideDependentRoassalShapeCommand new.
		self assert: hideDepCmd defaultMenuItemName equals: 'Hide dependent'.
		hideDepCmd readParametersFromContext: toolContext.
		hideDepCmd prepareFullExecutionInContext: toolContext.
		hideDepCmd execute.
		self
			deny: (diagramController hasControllerForModel: relation)
			description: 'OPHideDependentRoassalShapeCommand should hide dependent relation'.

		showDepCmd := OPShowDependentRoassalShapeCommand new.
		self assert: showDepCmd defaultMenuItemName equals: 'Show dependent'.
		showDepCmd readParametersFromContext: toolContext.
		showDepCmd prepareFullExecutionInContext: toolContext.
		showDepCmd execute.
		self
			assert: (diagramController hasControllerForModel: relation)
			description: 'OPShowDependentRoassalShapeCommand should show dependent relation again'.

		hideCmd := OPHideRoassalShapeCommand new.
		self assert: hideCmd defaultMenuItemName equals: 'Hide'.
		hideCmd readParametersFromContext: toolContext.
		hideCmd prepareFullExecutionInContext: toolContext.
		hideCmd execute.
		self
			deny: (diagramController hasControllerForModel: entity1)
			description: 'OPHideRoassalShapeCommand should hide the selected entity'
	] ensure: [ OPPluginRegistry resetDefault ]
]
