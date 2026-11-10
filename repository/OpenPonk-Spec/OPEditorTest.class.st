"
Tests editor lifecycle, canvas presentation, palette initialization, and tab management in the OpenPonk editor.
"
Class {
	#name : 'OPEditorTest',
	#superclass : 'TestCase',
	#instVars : [
		'editor',
		'workbench'
	],
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

{ #category : 'running' }
OPEditorTest >> setUp [
	"Prepares the editor instance for testing without opening a UI window."

	super setUp.
	editor := (OPEditor on: OPTestPlugin new)
		          application: SpApplication defaultApplication;
		          yourself.
	workbench := nil
]

{ #category : 'running' }
OPEditorTest >> tearDown [
	"Deterministically closes any open morphic windows associated with the test editor."

	editor ifNotNil: [ :activeEditor |
		activeEditor withWindowDo: [ :windowPresenter | windowPresenter isOpen ifTrue: [ windowPresenter close ] ] ].
	workbench ifNotNil: [ :currentWorkbench | currentWorkbench close ].
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

{ #category : 'tests' }
OPEditorTest >> testCloseWindowWithoutDiagramControllerDoesNotError [
	| window |
	window := editor open.
	window close.
	self deny: window isDisplayed description: 'Closed editor window should no longer be displayed'
]

{ #category : 'tests' }
OPEditorTest >> testEditorLayoutsSwitching [
	| layoutNames |
	[
		layoutNames := OPEditor availableLayoutNames.
		self assertCollection: layoutNames hasSameElements: #( 'Palette on left' 'Palette on right' ).
		self assert: OPEditor defaultLayout name equals: 'Palette on left'.
		self assert: OPEditor canvasSectionWidth > 0 description: 'canvasSectionWidth should be positive'.

		OPEditor layoutName: 'Palette on right'.
		self assert: OPEditor layoutName equals: 'Palette on right'.
		OPEditor setDefaultLayout.
		self assert: OPEditor layoutName equals: 'Palette on left'
	] ensure: [ OPEditor setDefaultLayout ]
]

{ #category : 'tests' }
OPEditorTest >> testInitializePresentersInstantiatesZoomToolbar [
	self assert: editor zoomToolbar isNotNil description: 'Editor zoomToolbar should be initialized'.
	self assert: (editor zoomToolbar isKindOf: OPZoomToolbarPresenter) description: 'zoomToolbar should be an OPZoomToolbarPresenter'.
	self assert: editor zoomToolbar canvasPresenter equals: editor canvasPresenter
]

{ #category : 'tests' }
OPEditorTest >> testTabClosedWhileClosingWorkbenchUpdatesDiagram [

	| testProject testContainerModel testDiagram activeEditor canvas initialCamera |
	testProject := OPProject named: 'CoreEditorCloseUnitTest'.
	testContainerModel := OPTestContainerModel new.
	testDiagram := OPOpenPonkDiagram forModelElement: testContainerModel.
	testProject addModel: testContainerModel.
	testProject addDiagram: testDiagram.

	workbench := OPWorkbench new.
	workbench pluginRegistry: OPPluginRegistry withAllForTesting.
	workbench openProject: testProject.
	workbench openEditorOnDiagram: testDiagram.
	activeEditor := workbench focusedEditor.
	canvas := activeEditor canvasPresenter canvas.
	canvas camera scale: 2.75.
	activeEditor tabClosedWhileClosingWorkbench: true.
	initialCamera := testDiagram camera.
	self assert: initialCamera isNotNil description: 'Diagram camera should be saved when tab closes'.
	self assert: (initialCamera scale - 2.75) abs < 0.001 description: 'Saved diagram camera scale should match canvas camera scale'
]

{ #category : 'tests' }
OPEditorTest >> testZoomToolbarButtonsFitWithinToolbarBounds [
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
		self assert: eachButtonMorph height <= 28 description: 'Each zoom toolbar button should fit within the 28px toolbar height' ]
]

{ #category : 'tests' }
OPEditorTest >> testZoomToolbarControlsEditorCanvasZoom [
	editor canvasPresenter zoom: 1.0.
	editor zoomToolbar zoomIn.
	self assert: (editor canvasPresenter zoom - 1.25) abs < 0.001 description: 'Zooming in should increase canvas zoom to 1.25'.
	editor zoomToolbar zoomReset.
	self assert: (editor canvasPresenter zoom - 1.0) abs < 0.001 description: 'Resetting zoom should restore canvas zoom to 1.0'
]
