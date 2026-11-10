"
Verifies OPNodeCreationTool, OPConnectionCreationTool, and OPEdgeCreationTargetController interaction workflows.
"
Class {
	#name : 'OPPaletteToolsTest',
	#superclass : 'TestCase',
	#instVars : [
		'container',
		'diagram',
		'testCanvas',
		'projectController',
		'diagramController',
		'palette'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPPaletteToolsTest >> setUp [

	| project workbench editor |
	super setUp.
	project := OPProject new.
	container := OPTestContainerModel new.
	project addModel: container.
	testCanvas := RSCanvas new.
	testCanvas @ OPRSSelectableCanvas.
	diagram := OPOpenPonkDiagram forModelElement: container.
	diagram canvas: testCanvas.
	project addDiagram: diagram.
	workbench := OPWorkbench new.
	projectController := OPProjectController forProject: project.
	projectController workbench: workbench.
	workbench instVarNamed: #projectController put: projectController.
	editor := OPEditor new.
	editor instVarNamed: #workbench put: workbench.
	diagramController := OPTestDiagramController new.
	diagramController instVarNamed: #editor put: editor.
	projectController addDiagramController: diagramController.
	diagramController
		model: container;
		diagramElement: diagram;
		canvasPresenter: (OPCanvasPresenter new
				 canvas: testCanvas;
				 yourself).
	palette := OPPalette new.
	palette owner: editor.
	palette instVarNamed: #diagramController put: diagramController
]

{ #category : 'tests' }
OPPaletteToolsTest >> testNodeCreationToolAndConnectionCreationToolLifecycle [
	| nodeTool completedNode completedEdge sourceCtrl targetCtrl connTool |
	completedNode := nil.
	nodeTool := OPNodeCreationTool new
		palette: palette;
		factory: [ OPTestEntityController new ];
		whenCreated: [ :ctrl | completedNode := ctrl ];
		yourself.
	nodeTool select.
	nodeTool hoveredController: diagramController.
	nodeTool selectedControllers: { diagramController } onPosition: 50 @ 60.
	self deny: completedNode equals: nil.
	self assertCollection: diagramController controllers includesAll: { completedNode }.
	nodeTool deselect.
	sourceCtrl := completedNode.
	targetCtrl := diagramController showInDiagramModel: (container add: OPTestEntityModel new).
	completedEdge := nil.
	connTool := OPConnectionCreationTool new
		palette: palette;
		factory: [ OPTestRelationController new ];
		whenCreated: [ :ctrl | completedEdge := ctrl ];
		yourself.
	connTool select.
	connTool hoveredController: sourceCtrl.
	connTool selectedControllers: { sourceCtrl }.
	self deny: (connTool instVarNamed: #edgeCreationTargetController) equals: nil.
	connTool hoveredController: targetCtrl.
	connTool selectedControllers: { targetCtrl }.
	self deny: completedEdge equals: nil.
	self assert: (connTool instVarNamed: #edgeCreationTargetController) equals: nil
]

{ #category : 'tests' }
OPPaletteToolsTest >> testPaletteEntryAndToolBuilders [
	| nodeEntry connEntry |
	self assert: OPPalette initialWidth equals: 180.
	self assert: OPPalette minWidth equals: 120.
	palette createPaletteFor: diagramController.
	palette newCreationTool: 'Entity' factory: [ OPTestEntityController new ] icon: nil.
	palette newConnectionCreationTool: 'Relation' factory: [ OPTestRelationController new ] icon: nil.
	palette newCreationTool: [ OPTestEntityController new ] with: [ :tool | ].
	palette newConnectionCreationTool: [ OPTestRelationController new ].
	nodeEntry := palette newCreationEntry: [ OPTestEntityController new ].
	connEntry := palette newConnectionCreationEntry: [ OPTestRelationController new ].
	palette newSeparator.
	self denyEmpty: palette entries.
	palette selectEntry: nodeEntry.
	self assert: palette selectedTool identicalTo: nodeEntry tool.
	palette selectTool: connEntry tool.
	self assert: palette selectedTool identicalTo: connEntry tool.
	palette selectSelectionTool.
	palette rebuildWidget
]
