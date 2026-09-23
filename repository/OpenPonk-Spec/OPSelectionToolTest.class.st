Class {
	#name : 'OPSelectionToolTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
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
	
	self assert: selectionTool selectedControllers isEmpty.
	mockWorkbench should receive openFormOn: nil
]

{ #category : 'tests' }
OPSelectionToolTest >> testSelectedControllersAccessor [
	| selectionTool |
	selectionTool := OPSelectionTool new.
	self assert: selectionTool selectedControllers isEmpty
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
	mockSelectable stub doHighlightShapes: Any.
	
	selectionTool selectedControllers: { renderedController }.
	
	mockSelectable should receive doHighlightShapes: { mockShape }
]
