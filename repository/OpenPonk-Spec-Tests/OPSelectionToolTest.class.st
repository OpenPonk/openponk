"
Tests element selection, multi-selection bounds, and canvas marquee tool interactions.
"
Class {
	#name : 'OPSelectionToolTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests-Palettes',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Palettes'
}

{ #category : 'tests' }
OPSelectionToolTest >> testDeselectControllerRemovesTargetAndUpdatesWorkbench [
	| selectionTool targetController remainingController mockWorkbench |
	selectionTool := OPSelectionTool new.
	mockWorkbench := Mock new.
	mockWorkbench stub openFormOn: Any.
	selectionTool stub workbench willReturn: mockWorkbench.
	targetController := Mock new.
	targetController stub isRendered willReturn: false.
	remainingController := Mock new.
	remainingController stub isRendered willReturn: false.
	selectionTool selectedControllers: { targetController . remainingController }.
	
	selectionTool deselectController: targetController.
	
	self assertCollection: selectionTool selectedControllers hasSameElements: { remainingController }.
	mockWorkbench should receive openFormOn: remainingController
]

{ #category : 'tests' }
OPSelectionToolTest >> testDeselectLastControllerClearsWorkbenchForm [

	| selectionTool targetController mockWorkbench |
	selectionTool := OPSelectionTool new.
	mockWorkbench := Mock new.
	mockWorkbench stub openFormOn: Any.
	selectionTool stub workbench willReturn: mockWorkbench.
	targetController := Mock new.
	targetController stub isRendered willReturn: false.
	selectionTool selectedControllers: { targetController }.

	selectionTool deselectController: targetController.
	self assertEmpty: selectionTool selectedControllers.
	mockWorkbench should receive openFormOn: nil
]

{ #category : 'tests' }
OPSelectionToolTest >> testPaletteReassignmentUnsubscribesFromPreviousDiagramController [

	| firstDiagramController secondDiagramController firstPalette secondPalette selectionTool |
	firstDiagramController := OPTestDiagramController new.
	secondDiagramController := OPTestDiagramController new.
	firstPalette := OPPalette new.
	firstPalette instVarNamed: #diagramController put: firstDiagramController.
	secondPalette := OPPalette new.
	secondPalette instVarNamed: #diagramController put: secondDiagramController.
	selectionTool := OPSelectionTool new
		                 palette: firstPalette;
		                 yourself.
	firstDiagramController announcer when: Announcement do: [ ] for: selectionTool.

	selectionTool palette: secondPalette.

	self
		assert: (firstDiagramController announcer subscriptions subscriptions noneSatisfy: [ :each | each subscriber == selectionTool ])
		description: 'Reassigning palette should unsubscribe selection tool from previous diagramController announcer'
]

{ #category : 'tests' }
OPSelectionToolTest >> testSelectedControllersAccessor [

	| selectionTool |
	selectionTool := OPSelectionTool new.
	self assertEmpty: selectionTool selectedControllers
]

{ #category : 'tests' }
OPSelectionToolTest >> testSelectedControllersHighlightsRenderedShapes [
	| selectionTool renderedController mockShape mockSelectable mockWorkbench |
	selectionTool := OPSelectionTool new.
	mockWorkbench := Mock new.
	mockWorkbench stub openFormOn: Any.
	selectionTool stub workbench willReturn: mockWorkbench.
	mockSelectable := Mock new.
	mockShape := RSBox new.
	mockShape propertyAt: OPRSSelectable put: mockSelectable.
	renderedController := Mock new.
	renderedController stub isRendered willReturn: true.
	renderedController stub roassalShape willReturn: mockShape.
	mockSelectable stub doHighlightShapes: Any onCanvas: Any.

	selectionTool selectedControllers: { renderedController }.

	mockSelectable should receive doHighlightShapes: { mockShape } onCanvas: mockShape canvas
]

{ #category : 'tests' }
OPSelectionToolTest >> testSelectedControllersUpdatesHighlightsFromPreviousRenderedShape [

	| selectionTool firstController secondController firstShape secondShape mockSelectable mockWorkbench |
	selectionTool := OPSelectionTool new.
	mockWorkbench := Mock new.
	mockWorkbench stub openFormOn: Any.
	selectionTool stub workbench willReturn: mockWorkbench.
	mockSelectable := Mock new.
	mockSelectable stub doHighlightShapes: Any onCanvas: Any.
	firstShape := RSBox new.
	firstShape propertyAt: OPRSSelectable put: mockSelectable.
	secondShape := RSBox new.
	firstController := Mock new.
	firstController stub isRendered willReturn: true.
	firstController stub roassalShape willReturn: firstShape.
	secondController := Mock new.
	secondController stub isRendered willReturn: true.
	secondController stub roassalShape willReturn: secondShape.

	selectionTool selectedControllers: { firstController }.
	selectionTool selectedControllers: { secondController }.

	(mockSelectable should receive doHighlightShapes: { secondShape } onCanvas: firstShape canvas) once
]
