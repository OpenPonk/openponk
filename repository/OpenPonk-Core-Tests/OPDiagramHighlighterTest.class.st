"
Unit tests verifying fill, stroke, batch replacement, timed flash, and lossless restoration in OPDiagramHighlighter.
"
Class {
	#name : 'OPDiagramHighlighterTest',
	#superclass : 'TestCase',
	#instVars : [
		'rootModel',
		'firstElement',
		'secondElement',
		'relationElement',
		'diagramController',
		'highlighter'
	],
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
}

{ #category : 'running' }
OPDiagramHighlighterTest >> setUp [

	super setUp.
	OPPluginRegistry setDefault: (OPPluginRegistry new
			 add: OPTestPlugin new;
			 yourself).
	self
		setUpModel;
		setUpDiagramController.
	highlighter := OPDiagramHighlighter on: diagramController.
	highlighter uiDispatcher: [ :aBlock | aBlock value ]
]

{ #category : 'running' }
OPDiagramHighlighterTest >> setUpDiagramController [

	| project diagram projectController |
	project := OPProject named: 'Highlighter Test'.
	project addModel: rootModel.
	diagram := OPOpenPonkDiagram forModelElement: rootModel.
	project addDiagram: diagram.
	projectController := OPProjectController forProject: project.
	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController
		canvasPresenter: OPHeadlessCanvasPresenter new;
		diagramElement: diagram;
		model: rootModel
]

{ #category : 'running' }
OPDiagramHighlighterTest >> setUpModel [

	rootModel := OPTestContainerModel new.
	rootModel instVarNamed: #uuid put: UUID new.
	firstElement := OPTestEntityModel new.
	firstElement instVarNamed: #uuid put: UUID new.
	secondElement := OPTestEntityModel new.
	secondElement instVarNamed: #uuid put: UUID new.
	relationElement := OPTestRelationModel new
		                   source: firstElement;
		                   target: secondElement;
		                   yourself.
	relationElement instVarNamed: #uuid put: UUID new.
	rootModel
		add: firstElement;
		add: secondElement;
		add: relationElement
]

{ #category : 'running' }
OPDiagramHighlighterTest >> tearDown [

	highlighter ifNotNil: [ highlighter clearAll ].
	OPPluginRegistry resetDefault.
	highlighter := nil.
	diagramController := nil.
	relationElement := nil.
	secondElement := nil.
	firstElement := nil.
	rootModel := nil.
	super tearDown
]

{ #category : 'tests' }
OPDiagramHighlighterTest >> testFillStrokeAndLineHighlightsPreserveCustomColorsAndRestoreOnClearAll [

	| firstController secondController relationController firstShape secondShape relationShape customFill |
	firstController := diagramController showInDiagramModel: firstElement.
	secondController := diagramController showInDiagramModel: secondElement.
	relationController := diagramController showInDiagramModel: relationElement.
	firstShape := firstController roassalShape.
	secondShape := secondController roassalShape.
	relationShape := relationController roassalShape.

	customFill := Color cyan.
	firstShape color: customFill.
	firstShape borderColor: Color blue.
	secondShape noBorder.
	relationShape color: Color darkGray.

	highlighter
		highlightFillOfModel: firstElement color: Color green;
		highlightStrokeOfModel: firstElement color: Color red;
		highlightStrokeOfModel: secondElement color: Color orange;
		highlightStrokeOfModel: relationElement color: Color green darker.

	self assert: firstShape color equals: Color green.
	self assert: firstShape borderColor equals: Color red.
	self assert: secondShape hasBorder description: 'Highlighting stroke on borderless shape must add temporary border'.
	self assert: secondShape borderColor equals: Color orange.
	self assert: relationShape color equals: Color green darker.

	highlighter clearAll.
	self assert: firstShape color equals: customFill.
	self assert: firstShape borderColor equals: Color blue.
	self deny: secondShape hasBorder description: 'Clearing highlight must restore noBorder on originally borderless shape'.
	self assert: relationShape color equals: Color darkGray
]

{ #category : 'tests' }
OPDiagramHighlighterTest >> testFlashFillCancelsPreviousTimerIgnoresStaleRestoreAndClearsOnClearAll [

	| firstController firstShape originalColor firstProcess secondProcess |
	firstController := diagramController showInDiagramModel: firstElement.
	firstShape := firstController roassalShape.
	originalColor := firstShape color.

	highlighter flashFillOfModel: firstElement color: Color lightOrange lighter duration: 5 seconds.
	firstProcess := (highlighter instVarNamed: #flashProcesses) at: firstController.
	self assert: firstShape color equals: Color lightOrange lighter.
	self deny: firstProcess isTerminated description: 'Flash timer process must be active'.

	highlighter flashFillOfModel: firstElement color: Color lightOrange lighter duration: 5 seconds.
	secondProcess := (highlighter instVarNamed: #flashProcesses) at: firstController.
	self assert: firstProcess isTerminated description: 'Re-flashing the same element must terminate prior timer'.
	self deny: secondProcess identicalTo: firstProcess.

	highlighter finishFlashRestoreFor: firstController process: firstProcess.
	self assert: firstShape color equals: Color lightOrange lighter.

	highlighter clearAll.
	self assert: secondProcess isTerminated description: 'clearAll must terminate active flash timers'.
	self assert: firstShape color equals: originalColor.
	self assertEmpty: (highlighter instVarNamed: #flashProcesses)
]

{ #category : 'tests' }
OPDiagramHighlighterTest >> testHighlightStrokeWithWidthPreservesAndRestoresNodeAndLineWidths [

	| firstController secondController relationController firstShape secondShape relationShape originalNodeWidth originalLineWidth |
	firstController := diagramController showInDiagramModel: firstElement.
	secondController := diagramController showInDiagramModel: secondElement.
	relationController := diagramController showInDiagramModel: relationElement.
	firstShape := firstController roassalShape.
	secondShape := secondController roassalShape.
	relationShape := relationController roassalShape.

	firstShape borderColor: Color blue.
	firstShape borderWidth: 1.5.
	originalNodeWidth := firstShape border width.
	secondShape noBorder.
	relationShape color: Color black.
	relationShape width: 1.
	originalLineWidth := relationShape border width.

	highlighter
		highlightStrokeOfModel: firstElement color: Color green darker width: 3;
		highlightStrokeOfModel: secondElement color: Color orange width: 2.5;
		highlightStrokeOfModel: relationElement color: Color orange width: 3.

	self assert: firstShape borderColor equals: Color green darker.
	self assert: firstShape border width equals: 3.
	self assert: secondShape borderColor equals: Color orange.
	self assert: secondShape border width equals: 2.5.
	self assert: relationShape color equals: Color orange.
	self assert: relationShape border width equals: 3.

	highlighter clearAll.
	self assert: firstShape borderColor equals: Color blue.
	self assert: firstShape border width equals: originalNodeWidth.
	self deny: secondShape hasBorder description: 'Clearing stroke highlight must restore noBorder on originally borderless shape'.
	self assert: relationShape color equals: Color black.
	self assert: relationShape border width equals: originalLineWidth
]

{ #category : 'tests' }
OPDiagramHighlighterTest >> testIgnoresHiddenAndUnrenderedElements [

	| firstController |
	highlighter
		highlightFillOfModel: firstElement color: Color green;
		highlightStrokeOfModel: firstElement color: Color red;
		flashFillOfModel: firstElement color: Color yellow duration: 1 second.
	self assertEmpty: (highlighter instVarNamed: #originalFillColors).
	self assertEmpty: (highlighter instVarNamed: #originalBorderStates).

	firstController := diagramController showInDiagramModel: firstElement.
	firstController removeRender.
	highlighter highlightFillOfModel: firstElement color: Color green.
	self assert: firstController roassalShape identicalTo: nil.
	self assertEmpty: (highlighter instVarNamed: #originalFillColors)
]

{ #category : 'tests' }
OPDiagramHighlighterTest >> testReplaceHighlightsDuringRestoresInactiveElementsOnly [

	| firstController secondController firstShape secondShape originalFirstColor originalSecondColor |
	firstController := diagramController showInDiagramModel: firstElement.
	secondController := diagramController showInDiagramModel: secondElement.
	firstShape := firstController roassalShape.
	secondShape := secondController roassalShape.
	originalFirstColor := firstShape color.
	originalSecondColor := secondShape color.

	highlighter replaceHighlightsDuring: [ highlighter highlightFillOfModel: firstElement color: Color green ].
	self assert: firstShape color equals: Color green.
	self assert: secondShape color equals: originalSecondColor.

	highlighter replaceHighlightsDuring: [ highlighter highlightFillOfModel: secondElement color: Color yellow ].
	self assert: firstShape color equals: originalFirstColor.
	self assert: secondShape color equals: Color yellow
]

{ #category : 'tests' }
OPDiagramHighlighterTest >> testRestoreFillAndStrokeIndependentlyPreservesOtherHighlight [

	| firstController firstShape originalFill originalBorderColor originalBorderWidth |
	firstController := diagramController showInDiagramModel: firstElement.
	firstShape := firstController roassalShape.
	firstShape color: Color white.
	firstShape borderColor: Color black.
	firstShape borderWidth: 1.
	originalFill := firstShape color.
	originalBorderColor := firstShape borderColor.
	originalBorderWidth := firstShape border width.

	highlighter
		highlightStrokeOfController: firstController color: Color green darker;
		highlightStrokeOfModel: firstElement color: Color green darker width: 2;
		highlightFillOfModel: firstElement color: Color lightOrange lighter.

	highlighter restoreFillOfModel: firstElement.
	self assert: firstShape color equals: originalFill.
	self assert: firstShape borderColor equals: Color green darker.
	self assert: firstShape border width equals: 2.

	highlighter restoreStrokeOfModel: firstElement.
	self assert: firstShape borderColor equals: originalBorderColor.
	self assert: firstShape border width equals: originalBorderWidth.

	highlighter
		highlightFillOfModel: firstElement color: Color yellow;
		highlightStrokeOfModel: firstElement color: Color red width: 3.
	firstController removeRender.
	highlighter
		restoreFillOfModel: firstElement;
		restoreStrokeOfModel: firstElement.
	self assertEmpty: (highlighter instVarNamed: #originalFillColors).
	self assertEmpty: (highlighter instVarNamed: #originalBorderStates)
]

{ #category : 'tests' }
OPDiagramHighlighterTest >> testRestoreModelValidFlashCompletionAndUnchangedShapeRestore [

	| firstController firstShape originalColor flashProcess |
	self assert: highlighter diagramController identicalTo: diagramController.
	self
		assert: (OPDiagramHighlighter on: diagramController) uiDispatcher isNotNil
		description: 'Default highlighter must initialize uiDispatcher'.

	firstController := diagramController showInDiagramModel: firstElement.
	firstShape := firstController roassalShape.
	originalColor := firstShape color.

	highlighter highlightFillOfModel: firstElement color: Color green.
	self assert: firstShape color equals: Color green.
	highlighter restoreModel: firstElement.
	self assert: firstShape color equals: originalColor.

	highlighter flashFillOfModel: firstElement color: Color yellow duration: 5 seconds.
	flashProcess := (highlighter instVarNamed: #flashProcesses) at: firstController.
	highlighter finishFlashRestoreFor: firstController process: flashProcess.
	self assert: firstShape color equals: originalColor.
	self assertEmpty: (highlighter instVarNamed: #flashProcesses).

	highlighter highlightFillOfModel: firstElement color: originalColor.
	highlighter restoreController: firstController.
	self assert: firstShape color equals: originalColor.

	highlighter highlightStrokeOfModel: firstElement color: Color red.
	firstController removeRender.
	highlighter restoreController: firstController.
	self assertEmpty: (highlighter instVarNamed: #originalBorderStates)
]
