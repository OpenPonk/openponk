"
Unit tests for OPDiagramController. 
Verifies the primary diagram loop, including element placement, sub-controller instantiation, and basic palette interactions.
"
Class {
	#name : 'OPDiagramControllerTest',
	#superclass : 'OPAbstractDiagramControllerTest',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
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

{ #category : 'tests - connecting' }
OPDiagramControllerTest >> testCanBeTargetForEntity [
	self
		assert:
			(controller
				canBeTargetFor: (controller newControllerFor: OPTestEntityModel new))
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

{ #category : 'tests - ui interaction' }
OPDiagramControllerTest >> testInitializePalette [

	| palette |
	palette := OPPalette new.
	self assert: palette items size equals: 2.
	controller initializePalette: palette.
	self assert: palette items size equals: 3
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
	self assert: um canUndo.

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

{ #category : 'tests - undo/redo' }
OPDiagramControllerTest >> testProjectControllerNilUnwiresUndoRedoCanvasUpdates [
	| projectController |
	projectController := OPProjectController new.
	controller projectController: projectController.
	controller projectController: nil.
	self deny: (projectController undoManager announcer hasSubscriber: controller)
]

{ #category : 'tests - undo/redo' }
OPDiagramControllerTest >> testProjectControllerWiresUndoRedoCanvasUpdates [
	| projectController |
	projectController := OPProjectController new.
	controller projectController: projectController.
	self assert: (projectController undoManager announcer hasSubscriber: controller)
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
	self deny: (controller controllers includes: targetController)
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

{ #category : 'tests - construction' }
OPDiagramControllerTest >> testShowModelInDiagram [

	| entity |
	controller model: model.
	entity := OPTestEntityModel new.
	controller showWithoutDependentInDiagramModel: entity
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
	controller canvasPresenter: (OPCanvasPresenter new canvas: RSCanvas new; yourself).

	self assert: (manager announcer hasSubscriber: controller)
]

{ #category : 'tests' }
OPDiagramControllerTest >> testUndoRedoUpdatesCanvasViaWeakSubscription [
	| manager |
	manager := controller undoManager.
	controller canvasPresenter: (OPCanvasPresenter new canvas: RSCanvas new; yourself).

	self assert: (manager announcer hasSubscriber: controller)
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
		self assert: (manager announcer hasSubscriber: tempController).
	] value.

	3 timesRepeat: [ Smalltalk garbageCollect ].

	self
		assert: weakHolder first isNil
		description: 'Diagram controller must be collected by GC when not strongly referenced elsewhere'
]
