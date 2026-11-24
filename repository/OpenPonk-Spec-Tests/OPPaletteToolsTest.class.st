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
	#category : 'OpenPonk-Spec-Tests-Palettes',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Palettes'
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
OPPaletteToolsTest >> testConnectionCreationToolDenyFeedbackGuardsAndCancelBeforeTarget [

	| sourceModel sourceCtrl connTool targetPlaceholder |
	sourceModel := OPTestEntityModel new.
	container add: sourceModel.
	sourceCtrl := diagramController showInDiagramModel: sourceModel.
	connTool := OPConnectionCreationTool new
		            palette: palette;
		            factory: [ OPTestRelationController new ];
		            yourself.
	connTool select.
	connTool hoveredController: diagramController.
	connTool selectedControllers: #(  ).
	connTool selectedControllers: { diagramController }.
	self assert: (connTool instVarNamed: #edgeCreationTargetController) identicalTo: nil.

	connTool selectedControllers: { sourceCtrl }.
	targetPlaceholder := connTool instVarNamed: #edgeCreationTargetController.
	self assert: targetPlaceholder class identicalTo: OPEdgeCreationTargetController.

	connTool hoveredController: diagramController.
	connTool selectedControllers: #(  ).
	connTool selectedControllers: { diagramController }.
	self assert: (connTool instVarNamed: #edgeCreationTargetController) identicalTo: targetPlaceholder.

	connTool deselect.
	self assert: (connTool instVarNamed: #edgeCreationTargetController) identicalTo: nil.
	self assert: targetPlaceholder diagramElement identicalTo: nil.
	targetPlaceholder remove.
	self assert: targetPlaceholder diagramElement identicalTo: nil
]

{ #category : 'tests' }
OPPaletteToolsTest >> testFilteredCommonItemsSignalsInformativeNotificationWithoutDeprecation [

	| initializer controllerWithIncompatibles notifications deprecations filtered |
	controllerWithIncompatibles := Mock new.
	controllerWithIncompatibles stub incompatiblePaletteItemNames willReturn: {
			OPBoundaryController paletteItemName.
			'UnknownItem' }.
	initializer := OPPaletteInitializer new
		               palette: palette;
		               diagramController: controllerWithIncompatibles;
		               yourself.
	notifications := OrderedCollection new.
	deprecations := OrderedCollection new.
	filtered := nil.
	[
		[ filtered := initializer filteredCommonItems ]
			on: Deprecation
			do: [ :deprecation |
					deprecations add: deprecation messageText.
					deprecation resume ] ]
		on: InformativeNotification
		do: [ :notification |
				notifications add: notification messageText.
				notification resume ].

	self assertEmpty: deprecations.
	self assert: notifications size equals: 1.
	self
		assert: (notifications first includesSubstring: 'UnknownItem')
		description: 'Notification should name the unknown incompatible palette item'.
	self assert: filtered size equals: 1
]

{ #category : 'tests' }
OPPaletteToolsTest >> testNodeCreationToolAndConnectionCreationToolLifecycle [

	| nodeTool completedNode completedEdge sourceCtrl targetCtrl connTool targetPlaceholder |
	completedNode := nil.
	nodeTool := OPNodeCreationTool new
		            palette: palette;
		            factory: [ OPTestEntityController new ];
		            whenCreated: [ :ctrl | completedNode := ctrl ];
		            yourself.
	nodeTool select.
	nodeTool hoveredController: diagramController.
	nodeTool selectedControllers: { diagramController } onPosition: 50 @ 60.
	self assert: completedNode class identicalTo: OPTestEntityController.
	self assert: completedNode diagramController identicalTo: diagramController.
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
	targetPlaceholder := connTool instVarNamed: #edgeCreationTargetController.
	self assert: targetPlaceholder class identicalTo: OPEdgeCreationTargetController.
	self assert: (targetPlaceholder instVarNamed: #edgeController) source identicalTo: sourceCtrl.
	connTool hoveredController: targetCtrl.
	connTool selectedControllers: { targetCtrl }.
	self assert: completedEdge class identicalTo: OPTestRelationController.
	self assertCollection: diagramController controllers includesAll: { completedEdge }.
	self assert: (connTool instVarNamed: #edgeCreationTargetController) identicalTo: nil
]

{ #category : 'tests' }
OPPaletteToolsTest >> testNodeCreationToolDenyFeedbackGuardsAndDefaultSelectedControllers [

	| entityModel existingEntityCtrl initialCount nodeTool createdController selectableSpy |
	entityModel := OPTestEntityModel new.
	container add: entityModel.
	existingEntityCtrl := diagramController showInDiagramModel: entityModel.
	initialCount := diagramController controllers size.
	nodeTool := OPNodeCreationTool new
		            palette: palette;
		            factory: [ OPTestEntityController new ];
		            yourself.
	nodeTool select.
	nodeTool hoveredController: existingEntityCtrl.
	nodeTool selectedControllers: #(  ).
	nodeTool selectedControllers: {
			diagramController.
			existingEntityCtrl }.
	nodeTool selectedControllers: { existingEntityCtrl }.
	self assert: diagramController controllers size equals: initialCount.

	nodeTool selectedControllers: { diagramController }.
	self assert: diagramController controllers size equals: initialCount + 1.

	createdController := nil.
	selectableSpy := Mock new.
	selectableSpy stub fakeClicked: Any.
	nodeTool := OPNodeCreationTool new
		            palette: palette;
		            factory: [ OPTestEntityController new ];
		            whenCreated: [ :ctrl | createdController := ctrl ];
		            yourself.
	nodeTool select.
	nodeTool selectedControllers: { diagramController } createdBy: [ :targetController |
			| created |
			created := nodeTool instVarNamed: #controller.
			targetController addAsTargetFor: created.
			created roassalShape propertyAt: OPRSSelectable put: selectableSpy ].
	self assert: createdController class identicalTo: OPTestEntityController.
	(selectableSpy should receive fakeClicked: createdController roassalShape) once
]

{ #category : 'tests' }
OPPaletteToolsTest >> testPaletteEntryAndToolBuilders [

	| creationItem creationWithIconItem connectionItem connectionWithIconItem nodeEntry connEntry |
	self assert: OPPalette initialWidth equals: 180.
	self assert: OPPalette minWidth equals: 120.
	palette createPaletteFor: diagramController.
	creationItem := palette newCreationTool: [ OPTestEntityController new ].
	palette newCreationTool: 'Entity' factory: [ OPTestEntityController new ] icon: nil.
	creationWithIconItem := palette items last.
	connectionItem := palette newConnectionCreationTool: [ OPTestRelationController new ].
	palette newConnectionCreationTool: 'Relation' factory: [ OPTestRelationController new ] icon: nil.
	connectionWithIconItem := palette items last.
	nodeEntry := palette newCreationEntry: [ OPTestEntityController new ].
	connEntry := palette newConnectionCreationEntry: [ OPTestRelationController new ].
	palette newSeparator.
	self denyEmpty: palette entries.

	creationItem performAction.
	self assert: palette selectedTool class identicalTo: OPNodeCreationTool.
	creationWithIconItem performAction.
	self assert: palette selectedTool class identicalTo: OPNodeCreationTool.
	connectionItem performAction.
	self assert: palette selectedTool class identicalTo: OPConnectionCreationTool.
	connectionWithIconItem performAction.
	self assert: palette selectedTool class identicalTo: OPConnectionCreationTool.

	palette selectEntry: nodeEntry.
	self assert: palette selectedTool identicalTo: nodeEntry tool.
	palette selectTool: connEntry tool.
	self assert: palette selectedTool identicalTo: connEntry tool.
	palette selectSelectionTool.
	self assert: palette selectedTool class identicalTo: OPSelectionTool.
	palette rebuildWidget
]

{ #category : 'tests' }
OPPaletteToolsTest >> testPaletteEscapeShortcutAndCommonInitializerFactories [

	| escapeEntry initializer commonItems noteEntry boundaryEntry noteController boundaryController |
	palette createPaletteFor: diagramController.
	palette selectEntry: palette entries second.
	self deny: palette selectedTool class identicalTo: OPSelectionTool.

	escapeEntry := palette contextKeyBindings keymaps detect: [ :each | each shortcut = Character escape ].
	escapeEntry action value.
	self assert: palette selectedTool class identicalTo: OPSelectionTool.

	initializer := OPPaletteInitializer new
		               palette: palette;
		               diagramController: diagramController;
		               yourself.
	commonItems := initializer allCommonItemsByName.
	noteEntry := (commonItems at: OPNoteController paletteItemName) value.
	boundaryEntry := (commonItems at: OPBoundaryController paletteItemName) value.
	noteController := (noteEntry tool instVarNamed: #factory) value.
	boundaryController := (boundaryEntry tool instVarNamed: #factory) value.
	self assert: noteController class identicalTo: OPNoteController.
	self assert: boundaryController class identicalTo: OPBoundaryController
]

{ #category : 'tests' }
OPPaletteToolsTest >> testPaletteToolBaseHooksAndEditorAccessor [

	| selectionTool nodeTool |
	selectionTool := OPSelectionTool new
		                 palette: palette;
		                 yourself.
	self assert: selectionTool editor identicalTo: palette editor.
	selectionTool hoveredController: diagramController.
	selectionTool selectedControllers: #(  ) onPosition: 10 @ 20.
	self assertEmpty: selectionTool selectedControllers.

	nodeTool := OPNodeCreationTool new
		            palette: palette;
		            yourself.
	nodeTool deselectController: diagramController.
	self assert: nodeTool editor identicalTo: palette editor
]

{ #category : 'tests' }
OPPaletteToolsTest >> testSelectToolRepeatedlyWithoutSelectedItemDoesNotFail [

	| freshPalette firstTool secondTool |
	freshPalette := OPPalette new.
	firstTool := OPNodeCreationTool new
		             palette: freshPalette;
		             factory: [ OPTestEntityController new ];
		             yourself.
	secondTool := OPConnectionCreationTool new
		              palette: freshPalette;
		              factory: [ OPTestRelationController new ];
		              yourself.

	freshPalette selectTool: firstTool.
	freshPalette selectTool: secondTool.

	self assert: freshPalette selectedTool identicalTo: secondTool
]
