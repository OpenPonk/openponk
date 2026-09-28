"
Tests editor lifecycle, canvas presentation, palette initialization, and tab management in the OpenPonk editor.
"
Class {
	#name : 'OPEditorTest',
	#superclass : 'TestCase',
	#instVars : [
		'editor'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPEditorTest >> setUp [
	"Prepares the editor instance for testing without opening a UI window."
	super setUp.
	editor := (OPEditor on: OPPluginRegistry default plugins first)
		application: SpApplication defaultApplication;
		yourself
]

{ #category : 'running' }
OPEditorTest >> tearDown [
	"Deterministically closes any open morphic windows associated with the test editor."
	editor ifNotNil: [ :activeEditor | 
		activeEditor withWindowDo: [ :windowPresenter | 
			windowPresenter isOpen ifTrue: [ windowPresenter close ] ] ].
	super tearDown
]

{ #category : 'tests - layout' }
OPEditorTest >> testCanvasSectionLayoutContainsZoomToolbar [
	"Verifies that the canvas section layout contains the zoom toolbar and no longer contains legacy canvasMenu or zoomLabel."
	| canvasSection bottomLayoutChildren |
	canvasSection := editor class currentLayout canvasSectionLayout.
	bottomLayoutChildren := (canvasSection children second isKindOf: SpBoxLayout)
		ifTrue: [ canvasSection children second children ]
		ifFalse: [ { canvasSection children second } ].
	self assertCollection: bottomLayoutChildren includesAny: #( #zoomToolbar ).
	self denyCollection: bottomLayoutChildren includesAny: #( #canvasMenu #zoomLabel )
]

{ #category : 'tests - lifecycle' }
OPEditorTest >> testCloseWindowWithoutDiagramControllerDoesNotError [
	"Verifies that closing an editor window whose diagramController is nil does not raise MessageNotUnderstood."
	| windowPresenter |
	windowPresenter := editor asWindow.
	windowPresenter open.
	windowPresenter close
]

{ #category : 'tests - presenters' }
OPEditorTest >> testInitializePresentersInstantiatesZoomToolbar [
	"Verifies that the editor initializes a zoom toolbar presenter bound to its canvas presenter."
	self assert: editor zoomToolbar isNotNil.
	self assert: (editor zoomToolbar isKindOf: OPZoomToolbarPresenter).
	self assert: editor zoomToolbar canvasPresenter equals: editor canvasPresenter
]

{ #category : 'tests' }
OPEditorTest >> testTabClosedWhileClosingWorkbenchUpdatesDiagram [
	| testProject testContainerModel testDiagram workbench activeEditor canvas initialCamera |
	testProject := OPProject named: 'CoreEditorCloseUnitTest'.
	testContainerModel := OPTestContainerModel new.
	testDiagram := OPOpenPonkDiagram forModelElement: testContainerModel.
	testProject addModel: testContainerModel.
	testProject addDiagram: testDiagram.

	[
		workbench := OPWorkbench new.
		workbench pluginRegistry: OPPluginRegistry withAllForTesting.
		workbench openProject: testProject.
		workbench openEditorOnDiagram: testDiagram.
		activeEditor := workbench focusedEditor.
		canvas := activeEditor canvasPresenter canvas.
		canvas camera scale: 2.75.

		activeEditor tabClosedWhileClosingWorkbench: true.

		initialCamera := testDiagram camera.
		self assert: initialCamera isNotNil.
		self assert: (initialCamera scale - 2.75) abs < 0.001.
	] ensure: [
		workbench ifNotNil: [ :currentWorkbench | currentWorkbench close ] ]
]

{ #category : 'tests - layout' }
OPEditorTest >> testZoomToolbarButtonsFitWithinToolbarBounds [
	"Verifies that all zoom toolbar buttons fit within the toolbar bounds and are not vertically clipped."
	| toolbarMorph buttonMorphs |
	editor build.
	toolbarMorph := editor zoomToolbar adapter widget.
	toolbarMorph extent: 300 @ 28.
	toolbarMorph fullBounds.
	buttonMorphs := toolbarMorph allMorphs select: [ :eachButton | 
		eachButton isKindOf: PluggableButtonMorph ].
	self assert: buttonMorphs size equals: 4.
	self assert: toolbarMorph height equals: 28.
	buttonMorphs do: [ :eachButtonMorph | 
		self assert: eachButtonMorph height <= 28 ]
]

{ #category : 'tests - presenters' }
OPEditorTest >> testZoomToolbarControlsEditorCanvasZoom [
	"Verifies that interacting with the editor zoom toolbar updates the canvas camera scale."
	editor canvasPresenter zoom: 1.0.
	editor zoomToolbar zoomIn.
	self assert: (editor canvasPresenter zoom - 1.25) abs < 0.001.
	editor zoomToolbar zoomReset.
	self assert: (editor canvasPresenter zoom - 1.0) abs < 0.001
]
