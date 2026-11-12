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
