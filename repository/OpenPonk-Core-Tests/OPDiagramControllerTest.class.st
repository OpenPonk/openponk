"
Unit tests for OPDiagramController. 
Verifies the primary diagram loop, including element placement, sub-controller instantiation, and basic palette interactions.
"
Class {
	#name : 'OPDiagramControllerTest',
	#superclass : 'OPAbstractDiagramControllerTest',
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
}

{ #category : 'constants' }
OPDiagramControllerTest >> controllerClass [
	^ OPTestDiagramController
]

{ #category : 'accessing' }
OPDiagramControllerTest >> diagramControllerClass [
	^ OPTestDiagramController
]

{ #category : 'accessing' }
OPDiagramControllerTest >> diagramModelClass [
	^ OPTestContainerModel
]

{ #category : 'constants' }
OPDiagramControllerTest >> modelClass [
	^ OPTestContainerModel
]

{ #category : 'tests - connecting' }
OPDiagramControllerTest >> testAddAsTargetForEntity [

	| entityController |
	entityController := controller newControllerFor:
		                    OPTestEntityModel new.
	controller addAsTargetFor: entityController.
	self
		assert: controller model entities asArray
		equals: { entityController model }.
	self
		assert: controller controllers asArray
		equals: { entityController }
]

{ #category : 'tests' }
OPDiagramControllerTest >> testAttachEditor [
	| editor form |
	editor := Mock new.
	form := Mock new.
	editor stub form willReturn: form.
	
	controller editor: editor.
	self assert: controller editor equals: editor.
	self assert: controller form equals: form
]

{ #category : 'tests' }
OPDiagramControllerTest >> testCanBeTargetForEntity [
	self
		assert:
			(controller
				canBeTargetFor: (controller newControllerFor: OPTestEntityModel new))
		description: 'Diagram controller should accept an entity controller as a target'
]

{ #category : 'tests' }
OPDiagramControllerTest >> testCanvasInteractionEventsAndCachesAndQueries [
	| project container entityA entityB testCanvas diagram projectController diagramController controllerA controllerB resizeEvent dragEvent waypointsEvent edgeShape |
	project := OPProject new.
	container := OPTestContainerModel new.
	entityA := container add: OPTestEntityModel new.
	entityB := container add: OPTestEntityModel new.
	project addModel: container.
	testCanvas := RSCanvas new.
	diagram := OPOpenPonkDiagram forModelElement: container.
	diagram canvas: testCanvas.
	project addDiagram: diagram.
	projectController := OPProjectController forProject: project.
	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController
		model: container;
		diagramElement: diagram;
		canvasPresenter: (OPHeadlessCanvasPresenter new canvas: testCanvas; yourself).
	diagramController addCanvasInteractionEventsFor: testCanvas.
	diagramController subscribeToUndoManager.
	controllerA := diagramController showInDiagramModel: entityA.
	controllerB := diagramController showInDiagramModel: entityB.
	self
		assert: (diagramController isVisibleInDiagram: entityA)
		description: 'Entity A should be reported as visible in diagram after showInDiagramModel:'.
	self assertCollection: diagramController visibleElements includesAll: { entityA . entityB }.
	self assert: (diagramController cachedControllerForModel: entityA) identicalTo: controllerA.
	self assert: (diagramController cachedControllerForRoassalShape: controllerA roassalShape) identicalTo: controllerA.
	self
		assert: (diagramController hasControllerForRoassalShape: controllerA roassalShape)
		description: 'Diagram controller should have controller for controllerA roassalShape'.
	self
		assert: (diagramController hasControllerForRoassalShape: testCanvas)
		description: 'Diagram controller should recognize its own canvas in hasControllerForRoassalShape:'.
	self
		deny: (diagramController hasControllerForRoassalShape: RSBox new)
		description: 'Unregistered RSBox should not have a controller in diagramController'.
	self
		assert: diagramController incompatiblePaletteItemNames isCollection
		description: 'incompatiblePaletteItemNames should return a collection'.
	resizeEvent := OPRSShapeResizedEvent new
		shape: controllerA roassalShape;
		oldPosition: 0 @ 0;
		newPosition: 10 @ 10;
		oldExtent: 50 @ 50;
		newExtent: 80 @ 60;
		yourself.
	diagramController shapeResized: resizeEvent.
	self assert: controllerA diagramElement bounds extent equals: 80 @ 60.
	projectController undoManager undo.
	self assert: controllerA diagramElement bounds extent equals: 50 @ 50.
	controllerA roassalShape translateTo: 40 @ 50.
	dragEvent := OPRSElementsDraggedEvent new
		shapes: { controllerA roassalShape };
		lines: #();
		initialPositions: (IdentityDictionary with: controllerA roassalShape -> (0 @ 0));
		initialLineControlPoints: IdentityDictionary new;
		initialAnchors: IdentityDictionary new;
		yourself.
	diagramController elementsDragged: dragEvent.
	self assert: controllerA diagramElement bounds position equals: 40 @ 50.
	projectController undoManager undo.
	self assert: controllerA diagramElement bounds position equals: 0 @ 0.
	edgeShape := OPTestEdge new
		source: controllerA diagramElement;
		target: controllerB diagramElement;
		renderIn: testCanvas;
		yourself.
	waypointsEvent := OPRSEdgeWaypointsChangedEvent new
		line: edgeShape roassalShape;
		oldWaypoints: { 0 @ 0 . 100 @ 100 };
		newWaypoints: { 0 @ 0 . 50 @ 80 . 100 @ 100 };
		yourself.
	diagramController edgeWaypointsChanged: waypointsEvent.
	self assert: edgeShape waypoints size equals: 3.
	projectController undoManager undo.
	self assert: edgeShape waypoints size equals: 2.
	diagramController updateAfterDiagramFocused.
	diagramController zoomToFit.
	diagramController ensureDeselected
]

{ #category : 'tests' }
OPDiagramControllerTest >> testCommonElementsAndBoundaryControllerDelegation [
	| noteCtrl boundaryCtrl |
	self assertEmpty: controller commonElementControllers.
	self assertEmpty: controller commonElements.
	noteCtrl := OPNoteController new.
	controller addController: noteCtrl.
	self assert: (controller commonElementControllers includes: noteCtrl) description: 'Diagram-only note controller should be included in commonElementControllers'.
	self assert: (controller commonElements includes: noteCtrl model) description: 'Note model should be included in commonElements'.

	boundaryCtrl := OPBoundaryController new.
	boundaryCtrl diagramController: controller.
	self assert: (boundaryCtrl canBeTargetFor: OPNoteController new) description: 'Boundary controller should delegate canBeTargetFor: to diagramController'
]

{ #category : 'tests' }
OPDiagramControllerTest >> testDeselectAllDelegatesToSelectionTool [
	| mockEditor mockPalette mockTool |
	mockEditor := Mock new.
	mockPalette := Mock new.
	mockTool := Mock new.

	mockEditor stub palette willReturn: mockPalette.
	mockPalette stub selectedTool willReturn: mockTool.
	mockTool stub deselect.

	controller editor: mockEditor.
	controller deselectAll.

	mockTool should receive deselect
]

{ #category : 'tests' }
OPDiagramControllerTest >> testDeselectControllerDelegatesToSelectionTool [
	| mockEditor mockPalette mockTool targetController |
	mockEditor := Mock new.
	mockPalette := Mock new.
	mockTool := Mock new.
	targetController := Mock new.

	mockEditor stub palette willReturn: mockPalette.
	mockPalette stub selectedTool willReturn: mockTool.
	mockTool stub deselectController: Any.

	controller editor: mockEditor.
	controller deselectController: targetController.

	mockTool should receive deselectController: targetController
]

{ #category : 'tests' }
OPDiagramControllerTest >> testDragResizeAndWaypointsWithoutUndoManager [
	| standaloneProject standaloneProjectController standaloneController container entityA entityB entityC controllerA controllerB controllerC edgeShape anchorConstraint anchoredDragEvent unchangedDragEvent lineDragEvent resizeEvent waypointsEvent multiDragEvent |
	standaloneProject := OPProject new.
	container := OPTestContainerModel new.
	entityA := OPTestEntityModel new.
	entityB := OPTestEntityModel new.
	entityC := OPTestEntityModel new.
	container add: entityA.
	container add: entityB.
	container add: entityC.
	standaloneProject addModel: container.
	standaloneProjectController := OPProjectController forProject: standaloneProject.
	standaloneProjectController instVarNamed: #undoManager put: nil.
	standaloneController := OPTestDiagramController new.
	standaloneProjectController addDiagramController: standaloneController.
	standaloneController
		model: container;
		diagramElement: (OPOpenPonkDiagram forModelElement: container);
		canvasPresenter: (OPHeadlessCanvasPresenter new canvas: RSCanvas new; yourself).
	controllerA := standaloneController showInDiagramModel: entityA.
	controllerB := standaloneController showInDiagramModel: entityB.
	controllerC := standaloneController showInDiagramModel: entityC.

	edgeShape := OPTestEdge new
		source: controllerA diagramElement;
		target: controllerB diagramElement;
		renderIn: standaloneController canvas;
		yourself.

	anchorConstraint := OPRSAnchorConstraint new
		balance: 0.75;
		distanceToLine: 20;
		yourself.
	anchorConstraint stick: controllerC roassalShape on: edgeShape roassalShape.
	controllerC roassalShape translateTo: 30 @ 40.
	anchoredDragEvent := OPRSElementsDraggedEvent new
		shapes: { RSBox new . controllerC roassalShape };
		lines: #();
		initialPositions: (IdentityDictionary with: controllerC roassalShape -> (0 @ 0));
		initialLineControlPoints: IdentityDictionary new;
		initialAnchors: (IdentityDictionary with: controllerC roassalShape -> #(0.25 10));
		yourself.
	standaloneController elementsDragged: anchoredDragEvent.
	self assert: controllerC diagramElement bounds position equals: 30 @ 40.

	unchangedDragEvent := OPRSElementsDraggedEvent new
		shapes: { controllerA roassalShape };
		lines: #();
		initialPositions: IdentityDictionary new;
		initialLineControlPoints: IdentityDictionary new;
		initialAnchors: IdentityDictionary new;
		yourself.
	standaloneController elementsDragged: unchangedDragEvent.

	controllerA roassalShape translateTo: 60 @ 70.
	controllerB roassalShape translateTo: 80 @ 90.
	multiDragEvent := OPRSElementsDraggedEvent new
		shapes: { controllerA roassalShape . controllerB roassalShape };
		lines: #();
		initialPositions: (IdentityDictionary
			with: controllerA roassalShape -> (30 @ 40)
			with: controllerB roassalShape -> (0 @ 0));
		initialLineControlPoints: IdentityDictionary new;
		initialAnchors: IdentityDictionary new;
		yourself.
	controller executeDragCommands: (standaloneController commandsForDraggedShapes: multiDragEvent).
	self assert: controllerA diagramElement bounds position equals: 60 @ 70.

	standaloneController edgeWaypointsChanged: (OPRSEdgeWaypointsChangedEvent new line: nil; yourself).
	standaloneController edgeWaypointsChanged: (OPRSEdgeWaypointsChangedEvent new line: RSLine new; yourself).
	standaloneController edgeWaypointsChanged: (OPRSEdgeWaypointsChangedEvent new line: controllerA roassalShape; yourself).
	waypointsEvent := OPRSEdgeWaypointsChangedEvent new
		line: edgeShape roassalShape;
		oldWaypoints: { 0 @ 0 . 100 @ 100 };
		newWaypoints: { 0 @ 0 . 100 @ 100 };
		yourself.
	standaloneController edgeWaypointsChanged: waypointsEvent.
	waypointsEvent := OPRSEdgeWaypointsChangedEvent new
		line: edgeShape roassalShape;
		oldWaypoints: { 0 @ 0 . 100 @ 100 };
		newWaypoints: { 0 @ 0 . 40 @ 60 . 100 @ 100 };
		yourself.
	standaloneController edgeWaypointsChanged: waypointsEvent.
	self assert: edgeShape waypoints size equals: 3.

	lineDragEvent := OPRSElementsDraggedEvent new
		shapes: #();
		lines: { RSLine new . edgeShape roassalShape };
		initialPositions: IdentityDictionary new;
		initialLineControlPoints: IdentityDictionary new;
		initialAnchors: IdentityDictionary new;
		yourself.
	standaloneController elementsDragged: lineDragEvent.

	lineDragEvent := OPRSElementsDraggedEvent new
		shapes: #();
		lines: { edgeShape roassalShape };
		initialPositions: IdentityDictionary new;
		initialLineControlPoints: (IdentityDictionary with: edgeShape roassalShape -> { 10 @ 10 });
		initialAnchors: IdentityDictionary new;
		yourself.
	standaloneController elementsDragged: lineDragEvent.
	self assert: edgeShape waypoints size equals: 3.

	resizeEvent := OPRSShapeResizedEvent new
		shape: nil;
		yourself.
	standaloneController shapeResized: resizeEvent.
	resizeEvent := OPRSShapeResizedEvent new
		shape: controllerA roassalShape;
		oldPosition: 60 @ 70;
		newPosition: 60 @ 70;
		oldExtent: 50 @ 50;
		newExtent: 50 @ 50;
		yourself.
	standaloneController shapeResized: resizeEvent.
	resizeEvent := OPRSShapeResizedEvent new
		shape: controllerA roassalShape;
		oldPosition: 60 @ 70;
		newPosition: 65 @ 75;
		oldExtent: 50 @ 50;
		newExtent: 90 @ 70;
		yourself.
	standaloneController shapeResized: resizeEvent.
	self assert: controllerA diagramElement bounds extent equals: 90 @ 70
]

{ #category : 'tests' }
OPDiagramControllerTest >> testElementControllerAndDiagramElementInteractionsAndQueries [
	| project container entityA entityB testCanvas diagram projectController diagramController controllerA controllerB elementA nonContainerEdge acceptFeedback denyFeedback stonString restoredElement |
	project := OPProject new.
	container := OPTestContainerModel new.
	entityA := container add: OPTestEntityModel new.
	entityB := container add: OPTestEntityModel new.
	project addModel: container.
	testCanvas := RSCanvas new.
	testCanvas @ OPRSSelectableCanvas.
	diagram := OPOpenPonkDiagram forModelElement: container.
	diagram canvas: testCanvas.
	project addDiagram: diagram.
	projectController := OPProjectController forProject: project.
	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController
		model: container;
		diagramElement: diagram;
		canvasPresenter: (OPHeadlessCanvasPresenter new canvas: testCanvas; yourself).
	controllerA := diagramController showInDiagramModel: entityA.
	controllerB := diagramController showInDiagramModel: entityB.
	elementA := controllerA diagramElement.
	self assert: controllerA asViewModel identicalTo: controllerA viewModel.
	self assert: controllerA formEventsAnnouncer identicalTo: controllerA viewModel announcer.
	self
		assert: controllerA isTargetUsedAsContainer
		description: 'Default element controller should use target as container'.
	self assert: (controllerA parentModelInTarget: diagramController) identicalTo: container.
	self
		deny: controllerA isCommon
		description: 'Standard element controller should not be marked as common'.
	self
		assert: controllerA elementsToShowInside isCollection
		description: 'elementsToShowInside should answer a collection'.
	self
		assert: controllerA dependentControllers isCollection
		description: 'dependentControllers should answer a collection'.
	self
		deny: (controllerA creationCommandIn: container andShowInDiagram: diagramController)
		equals: nil.
	self assert: controllerA intendedOwningDiagramElement identicalTo: diagram.
	self assert: controllerA diagramElementOwnerWithPossibleController identicalTo: diagram.
	acceptFeedback := controllerA showAcceptFeedbackFor: controllerB.
	acceptFeedback ifNotNil: [ acceptFeedback remove ].
	denyFeedback := controllerA showDenyFeedbackFor: controllerB.
	denyFeedback ifNotNil: [ denyFeedback remove ].
	self
		assert: elementA isDiagramElement
		description: 'Diagram element should answer true to isDiagramElement'.
	self
		deny: elementA isTransient
		description: 'Standard diagram element should not be transient'.
	self
		assert: elementA isRenderedWithOwnedElements
		description: 'Rendered element without unrendered children should report isRenderedWithOwnedElements = true'.
	self assert: elementA topMostOwningElement identicalTo: diagram.
	self denyEmpty: elementA styleTypeNames.
	self denyEmpty: elementA allShapesPositionableByUser.
	self assertEmpty: elementA innerNodeElements.
	self assertEmpty: elementA innerNodeRoassalShapes.
	self assertEmpty: elementA directNodeRoassalShapes.
	self assertEmpty: elementA innerDraggableRoassalShapes.
	elementA pushFront.
	elementA pushBack.
	elementA roundPositionsAndExtents.
	nonContainerEdge := OPTestEdge new.
	self
		deny: nonContainerEdge isContainer
		description: 'Edge diagram element should not be a container'.
	self
		deny: nonContainerEdge movesWithOtherShape
		description: 'Edge diagram element should not move with other shape by default'.
	self
		deny: nonContainerEdge supportsColorChange
		description: 'OPTestEdge without color accessors should not support color change'.
	self should: [ nonContainerEdge adaptBoundsToInnerBounds: (0 @ 0 corner: 10 @ 10) ] raise: Error.
	stonString := STON toString: elementA.
	restoredElement := STON fromString: stonString.
	self assert: restoredElement class equals: elementA class.
	controllerA ensureDeselected
]

{ #category : 'tests' }
OPDiagramControllerTest >> testHideAllElementsAndApplyDefaultLayoutAndWillRenderWarning [
	| pluginRegistry entityA entityB controllerA initialPosition |
	pluginRegistry := OPPluginRegistry new.
	pluginRegistry add: OPTestPlugin new.
	[
		OPPluginRegistry setDefault: pluginRegistry.
		controller layouter: nil.
		self assert: controller layouter class equals: OPNoLayouter.
		controller layouter: (OPTestLayouter new diagramController: controller; yourself).

		entityA := OPTestEntityModel new.
		entityB := OPTestEntityModel new.
		model add: entityA.
		model add: entityB.
		controllerA := controller showInDiagramModel: entityA.
		controller showInDiagramModel: entityB.
		self assert: controller controllers size equals: 2.
		self assertCollection: controller modelsWithController hasSameElements: { entityA . entityB }.
		self assert: (controller modelForRoassalShape: controllerA roassalShape) identicalTo: entityA.
		self assert: (controller roassalShapeForModel: entityA) identicalTo: controllerA roassalShape.

		controller validate.

		controllerA diagramElement bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 50 @ 50).
		controllerA roassalShape translateTo: 0 @ 0.
		initialPosition := controllerA diagramElement bounds position.
		controller applyDefaultLayout.
		self assert: controllerA diagramElement bounds position equals: initialPosition + (50 @ 50).

		controller willRender: controllerA.
		self
			should: [ controller willRender: controllerA ]
			raise: Warning.
		controller rendered: controllerA.
		controller rendered: controllerA.

		controller hideAllElements.
		self assertEmpty: controller controllers.

		controller showAllElements.
		self assert: controller controllers size equals: 2.

		controller removeAllControllers.
		self assertEmpty: controller controllers
	] ensure: [ OPPluginRegistry resetDefault ]
]

{ #category : 'tests' }
OPDiagramControllerTest >> testLayoutIsUndoable [
	| node1 node2 initialPos1 initialPos2 um |
	um := controller undoManager.
	controller layouter: (OPTestLayouter new diagramController: controller; yourself).
	node1 := controller newControllerFor: OPTestEntityModel new.
	node2 := controller newControllerFor: OPTestEntityModel new.
	controller addAsTargetFor: node1.
	controller addAsTargetFor: node2.
	node1 diagramElement bounds: (OPNodeBounds withPosition: 0 @ 0 extent: 50 @ 50).
	node2 diagramElement bounds: (OPNodeBounds withPosition: 10 @ 10 extent: 50 @ 50).
	node1 roassalShape translateTo: 0 @ 0.
	node2 roassalShape translateTo: 10 @ 10.
	initialPos1 := node1 diagramElement bounds position.
	initialPos2 := node2 diagramElement bounds position.
	controller layouter defaultLayout.
	self assert: node1 diagramElement bounds position equals: initialPos1 + (50 @ 50).
	self assert: node2 diagramElement bounds position equals: initialPos2 + (50 @ 50).
	self assert: um canUndo description: 'Undo manager should record the layout change as undoable'.
	controller undo.
	self assert: node1 diagramElement bounds position equals: initialPos1.
	self assert: node2 diagramElement bounds position equals: initialPos2.
	controller redo.
	self assert: node1 diagramElement bounds position equals: initialPos1 + (50 @ 50).
	self assert: node2 diagramElement bounds position equals: initialPos2 + (50 @ 50)
]

{ #category : 'tests' }
OPDiagramControllerTest >> testModelClass [
	| plugin pluginRegistry |
	plugin := OPPlugin new.
	plugin stub modelClass willReturn: self diagramModelClass.
	plugin stub diagramControllerClass willReturn: self diagramControllerClass.
	pluginRegistry := OPPluginRegistry new add: plugin.
	[ OPPluginRegistry setDefault: pluginRegistry.
	self assert: controller modelClass equals: self diagramModelClass ]
		ensure: [ OPPluginRegistry setDefault: nil ]
]

{ #category : 'tests' }
OPDiagramControllerTest >> testPluginAndWorkbenchAnnouncerAndAllDeselectedEvents [
	| plugin pluginRegistry standaloneController nilCanvasPresenter customAnnouncer deselectedCount |
	standaloneController := nil.
	plugin := OPPlugin new.
	plugin stub diagramControllerClass willReturn: OPTestDiagramController.
	pluginRegistry := OPPluginRegistry new.
	pluginRegistry add: plugin.
	[
		OPPluginRegistry setDefault: pluginRegistry.
		standaloneController := OPTestDiagramController new.
		self assert: standaloneController plugin identicalTo: plugin
	] ensure: [ OPPluginRegistry resetDefault ].

	nilCanvasPresenter := OPHeadlessCanvasPresenter new
		instVarNamed: #canvas put: nil;
		yourself.
	standaloneController canvasPresenter: nilCanvasPresenter.

	customAnnouncer := Announcer new.
	standaloneController workbenchAnnouncer: customAnnouncer.
	self assert: standaloneController workbenchAnnouncer identicalTo: customAnnouncer.

	deselectedCount := 0.
	standaloneController whenAllDeselectedDo: [ deselectedCount := deselectedCount + 1 ] for: self.
	standaloneController deselectAll.
	self assert: deselectedCount equals: 1
]

{ #category : 'tests' }
OPDiagramControllerTest >> testProjectControllerNilUnwiresUndoRedoCanvasUpdates [
	| projectController |
	projectController := OPProjectController new.
	controller projectController: projectController.
	controller projectController: nil.
	self
		deny: (projectController undoManager announcer hasSubscriber: controller)
		description: 'Setting projectController to nil should unsubscribe diagram controller from undoManager'
]

{ #category : 'tests' }
OPDiagramControllerTest >> testProjectControllerWiresUndoRedoCanvasUpdates [
	| projectController |
	projectController := OPProjectController new.
	controller projectController: projectController.
	self
		assert: (projectController undoManager announcer hasSubscriber: controller)
		description: 'Setting projectController should subscribe diagram controller to undoManager'
]

{ #category : 'tests' }
OPDiagramControllerTest >> testReentrancyGuardsAndUpdateAfterDiagramFocusedAndIncompatibleItems [
	| entityA entityB controllerA orphanElement undoManager guardFired restrictedController |
	entityA := OPTestEntityModel new.
	entityB := OPTestEntityModel new.
	model add: entityA.
	model add: entityB.
	controllerA := controller showInDiagramModel: entityA.
	controller showInDiagramModel: entityB.

	orphanElement := controllerA diagramElement class forModelElement: OPTestEntityModel new.
	orphanElement owningElement: controller diagramElement.
	controller diagramElement ownedElements add: orphanElement.
	model entities remove: entityB.
	controller updateAfterDiagramFocused.
	self deny: (controller hasControllerForModel: entityB) description: 'Controller for removed model should be cleaned up on diagram focus'.
	self assert: (controller hasControllerForModel: entityA) description: 'Controller for remaining model should be preserved on diagram focus'.
	self assert: orphanElement owningElement isNil description: 'Orphan diagram element should be detached on diagram focus'.

	undoManager := controller undoManager.
	guardFired := false.
	undoManager execute: (OPRenameProjectCommand project: controller project newName: 'TempProjectName').
	controller project announcer
		when: OPProjectRenamed
		do: [ :announcement |
			undoManager isExecutingUndoRedo ifTrue: [
				guardFired := true.
				controller elementsDragged: OPRSElementsDraggedEvent new.
				controller shapeResized: OPRSShapeResizedEvent new.
				controller edgeWaypointsChanged: OPRSEdgeWaypointsChangedEvent new ] ]
		for: self.
	[ undoManager undo ] ensure: [ controller project announcer unsubscribe: self ].
	self assert: guardFired description: 'Reentrancy guards should be exercised during undo execution'.
	self assert: controllerA diagramElement isNotNil description: 'Reentrancy guards should ignore events during undo'.

	restrictedController := OPTestDiagramController new.
	(restrictedController stub canBeTargetFor: Any) willReturn: false.
	self
		assertCollection: restrictedController incompatiblePaletteItemNames
		includesAll: { OPBoundaryController paletteItemName }
]

{ #category : 'tests' }
OPDiagramControllerTest >> testRemoveControllerDeselectsController [

	| mockEditor mockPalette mockTool targetController |
	mockEditor := Mock new.
	mockPalette := Mock new.
	mockTool := Mock new.
	targetController := Mock new.

	mockEditor stub palette willReturn: mockPalette.
	mockPalette stub selectedTool willReturn: mockTool.
	mockTool stub deselectController: Any.

	controller editor: mockEditor.
	controller controllers add: targetController.
	controller removeController: targetController.

	mockTool should receive deselectController: targetController.
	self denyCollection: controller controllers includesAny: { targetController }
]

{ #category : 'tests' }
OPDiagramControllerTest >> testRemoveShapeShowDiagramElementAndDiagramFocusedEdgeCases [
	| standaloneProject standaloneProjectController standaloneController container entityA entityB controllerA controllerB nestedParent nestedChild duplicateElement unrenderedDiagram unrenderedNote |
	standaloneProject := OPProject new.
	container := OPTestContainerModel new.
	entityA := OPTestEntityModel new.
	entityB := OPTestEntityModel new.
	container add: entityA.
	container add: entityB.
	standaloneProject addModel: container.
	standaloneProjectController := OPProjectController forProject: standaloneProject.
	standaloneProjectController instVarNamed: #undoManager put: nil.
	standaloneController := OPTestDiagramController new.
	standaloneProjectController addDiagramController: standaloneController.
	standaloneController
		model: container;
		diagramElement: (OPOpenPonkDiagram forModelElement: container);
		canvasPresenter: (OPHeadlessCanvasPresenter new canvas: RSCanvas new; yourself).
	controllerA := standaloneController showInDiagramModel: entityA.
	controllerB := standaloneController showInDiagramModel: entityB.

	standaloneController removeModelOfRoassalShape: nil.
	standaloneController removeModelOfRoassalShape: RSBox new.
	standaloneController removeModelOfRoassalShape: controllerB roassalShape.
	self deny: (standaloneController hasControllerForModel: entityB) description: 'Entity B should be removed without undoManager'.

	standaloneController showWithoutDependentInDiagram: standaloneController.
	self
		should: [ standaloneController showWithoutDependentInDiagram: controller ]
		raise: Error.

	nestedParent := OPNote new.
	nestedChild := OPNote new.
	nestedChild owningElement: nestedParent.
	nestedParent ownedElements add: nestedChild.
	standaloneController showDiagramElement: nestedParent.
	self assert: nestedChild isRendered description: 'Child diagram element should be rendered recursively by showDiagramElement:'.

	duplicateElement := controllerA diagramElement class forModelElement: entityA.
	self
		should: [ standaloneController showDiagramElement: duplicateElement ]
		raise: Error.

	unrenderedDiagram := OPOpenPonkDiagram forModelElement: container.
	unrenderedNote := OPNote new.
	unrenderedNote owningElement: unrenderedDiagram.
	unrenderedDiagram ownedElements add: unrenderedNote.
	standaloneController diagramElement: unrenderedDiagram.
	standaloneController diagramFocused.
	self assert: unrenderedNote isRendered description: 'diagramFocused should render owned elements when diagram is not yet rendered'
]

{ #category : 'tests' }
OPDiagramControllerTest >> testSelectController [
	| mockEditor mockPalette mockTool targetCtrl |
	mockEditor := Mock new.
	mockPalette := Mock new.
	mockTool := Mock new.
	targetCtrl := Mock new.

	mockEditor stub palette willReturn: mockPalette.
	mockPalette stub selectSelectionTool willReturn: mockPalette.
	mockPalette stub selectedTool willReturn: mockTool.
	mockTool stub selectedControllers: Any.

	controller editor: mockEditor.
	controller selectController: targetCtrl.

	mockTool should receive selectedControllers: { targetCtrl }
]

{ #category : 'tests' }
OPDiagramControllerTest >> testSelfQueriesAndMouseInteractionsAndSelectionBranches [
	| entityA controllerA mockEditor mockPalette nonSelectionTool dummySelectionTool mockTool mockForm selectableCanvas |
	entityA := OPTestEntityModel new.
	model add: entityA.
	controllerA := controller showInDiagramModel: entityA.

	self assert: (controller controllerForModel: model) identicalTo: controller.
	self assert: (controller controllerForModel: model ifNone: [ nil ]) identicalTo: controller.
	self
		assert: (controller controllerForModel: model ifFound: [ :found | found ] ifNone: [ nil ])
		identicalTo: controller.
	self assert: (controller controllerForRoassalShape: controller canvas) identicalTo: controller.
	self assert: (controller controllerForRoassalShape: controller canvas ifNone: [ nil ]) identicalTo: controller.

	self assertEmpty: controller selectedControllers.

	mockEditor := Mock new.
	mockPalette := Mock new.
	nonSelectionTool := OPCreationTool new.
	dummySelectionTool := OPDiagramController new.
	mockTool := Mock new.
	mockForm := Mock new.
	controller editor: mockEditor.

	mockEditor stub palette willReturn: nil.
	self assertEmpty: controller selectedControllers.

	mockEditor stub palette willReturn: mockPalette.
	mockPalette stub selectedTool willReturn: nil.
	self assertEmpty: controller selectedControllers.

	mockPalette stub selectedTool willReturn: nonSelectionTool.
	self assertEmpty: controller selectedControllers.

	mockPalette stub selectedTool willReturn: dummySelectionTool.
	self assertEmpty: controller selectedControllers.

	mockPalette stub selectedTool willReturn: mockTool.
	mockPalette stub selectSelectionTool willReturn: mockPalette.
	mockTool stub hoveredController: Any.
	mockTool stub selectedControllers willReturn: { controllerA }.
	mockTool stub selectedControllers: Any.
	mockTool stub selectedControllers: Any onPosition: Any.
	mockEditor stub form willReturn: mockForm.
	mockForm stub focusFirstInput.
	mockForm stub viewModel: Any.

	controller openInForm: controllerA viewModel.
	mockForm should receive viewModel: controllerA viewModel.

	controllerA roassalShape announce: (RSMouseEnter new shape: controllerA roassalShape; yourself).
	mockTool should receive hoveredController: controllerA.

	controllerA roassalShape announce: (RSMouseDoubleClick new shape: RSBox new; yourself).
	controllerA roassalShape announce: (RSMouseDoubleClick new shape: controllerA roassalShape; yourself).
	mockTool should receive selectedControllers: { controllerA }.
	mockForm should receive focusFirstInput.

	controller selectedShapes: { controllerA roassalShape } onPosition: 15 @ 25.
	mockTool should receive selectedControllers: { controllerA } onPosition: 15 @ 25.

	controllerA roassalShape @ OPRSSelectable.
	selectableCanvas := controller canvas propertyAt: OPRSSelectableCanvas.
	selectableCanvas
		selectShapes: (RSGroup with: controllerA roassalShape)
		byEvent: (RSMouseClick new canvas: controller canvas; position: 0 @ 0; yourself).
	mockTool stub deselect.
	controller deselectAll.
	self assertEmpty: selectableCanvas selectedShapes
]

{ #category : 'tests' }
OPDiagramControllerTest >> testShowModelInDiagram [
	| entity shownController |
	controller model: model.
	entity := OPTestEntityModel new.
	shownController := controller showWithoutDependentInDiagramModel: entity.
	self
		assert: (controller hasControllerForModel: entity)
		description: 'Diagram controller should register a controller for the shown entity'.
	self assertCollection: controller controllers includesAll: { shownController }
]

{ #category : 'tests - construction' }
OPDiagramControllerTest >> testShowModelInDiagramAttachesController [

	| entity |
	controller model: model.
	entity := OPTestEntityModel new.
	controller showWithoutDependentInDiagramModel: entity.
	self
		shouldnt: (controller controllerForModel: entity)
		raise: NotFound
]

{ #category : 'tests' }
OPDiagramControllerTest >> testUndoRedoCapabilitiesAndProjectAndShapeQueries [
	| emptyProjectController standaloneController project container projectController diagram diagramController entity entityController |
	emptyProjectController := OPProjectController new.
	emptyProjectController instVarNamed: #undoManager put: nil.
	standaloneController := OPTestDiagramController new.
	standaloneController
		projectController: emptyProjectController;
		canvasPresenter: OPHeadlessCanvasPresenter new.
	self deny: standaloneController canUndo description: 'Controller with nil undoManager cannot undo'.
	self deny: standaloneController canRedo description: 'Controller with nil undoManager cannot redo'.
	self assert: standaloneController roassalShape identicalTo: standaloneController canvas.
	self
		should: [ OPDiagramController new initializePalette: nil ]
		raise: SubclassResponsibility.

	project := OPProject new.
	container := OPTestContainerModel new.
	project addModel: container.
	diagram := OPOpenPonkDiagram forModelElement: container.
	project addDiagram: diagram.
	projectController := OPProjectController forProject: project.
	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	diagramController
		model: container;
		diagramElement: diagram;
		canvasPresenter: OPHeadlessCanvasPresenter new.
	self assert: diagramController project identicalTo: project.

	entity := OPTestEntityModel new.
	container add: entity.
	entityController := diagramController showInDiagramModel: entity.
	projectController undoManager execute: (OPChangeBoundsCommand
		element: entityController diagramElement
		oldBounds: (OPNodeBounds withPosition: 0 @ 0 extent: 50 @ 50)
		newBounds: (OPNodeBounds withPosition: 20 @ 30 extent: 50 @ 50)).
	self assert: diagramController canUndo description: 'Controller should report canUndo after command execution'.
	self deny: diagramController canRedo description: 'Controller should report canRedo = false before undo'.
	diagramController undo.
	self deny: diagramController canUndo description: 'Controller should report canUndo = false after undo'.
	self assert: diagramController canRedo description: 'Controller should report canRedo = true after undo'
]

{ #category : 'tests' }
OPDiagramControllerTest >> testUndoRedoUpdatesCanvas [
	| manager |
	manager := controller undoManager.
	controller canvasPresenter: (OPHeadlessCanvasPresenter new canvas: RSCanvas new; yourself).
	self
		assert: (manager announcer hasSubscriber: controller)
		description: 'Diagram controller should be subscribed to undoManager announcer'
]

{ #category : 'tests' }
OPDiagramControllerTest >> testUndoRedoUpdatesCanvasViaWeakSubscription [
	| manager |
	manager := controller undoManager.
	controller canvasPresenter: (OPHeadlessCanvasPresenter new canvas: RSCanvas new; yourself).
	self
		assert: (manager announcer hasSubscriber: controller)
		description: 'Diagram controller should be weakly subscribed to undoManager announcer'
]

{ #category : 'tests' }
OPDiagramControllerTest >> testWeakSubscriptionAllowsGarbageCollection [
	| manager weakHolder |
	manager := OPUndoManager new.
	[
		| tempController projectController |
		projectController := OPProjectController new.
		projectController instVarNamed: #undoManager put: manager.
		tempController := OPDiagramController new.
		projectController addDiagramController: tempController.
		weakHolder := WeakArray with: tempController.
		self
			assert: (manager announcer hasSubscriber: tempController)
			description: 'Diagram controller should be subscribed to undoManager while referenced'
	] value.
	3 timesRepeat: [ Smalltalk garbageCollect ].
	self
		assert: weakHolder first isNil
		description: 'Diagram controller must be collected by GC when not strongly referenced elsewhere'
]

{ #category : 'tests' }
OPDiagramControllerTest >> testWithoutSelectionDoDeselectsAndRestoresSelection [
	| mockEditor mockPalette mockTool targetController wasExecuted |
	mockEditor := Mock new.
	mockPalette := Mock new.
	mockTool := Mock new.
	targetController := Mock new.
	wasExecuted := false.

	mockEditor stub palette willReturn: mockPalette.
	mockPalette stub selectSelectionTool willReturn: mockPalette.
	mockPalette stub selectedTool willReturn: mockTool.
	mockTool stub deselect.
	mockTool stub selectedControllers willReturn: { targetController }.
	mockTool stub selectedControllers: Any.

	controller editor: mockEditor.
	controller selectController: targetController.

	controller withoutSelectionDo: [
		wasExecuted := true.
		mockTool should receive deselect ].

	self assert: wasExecuted description: 'Execution block must be evaluated'.
	mockTool should receive selectedControllers: { targetController }
]
