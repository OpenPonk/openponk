"
Tests editor lifecycle, canvas presentation, palette initialization, and tab management in the OpenPonk editor.
"
Class {
	#name : 'OPEditorTest',
	#superclass : 'OPAbstractUITest',
	#instVars : [
		'editor',
		'workbench'
	],
	#category : 'OpenPonk-Spec-Tests-Windows',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Windows'
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
OPEditorTest >> testCreateCommandContextAndTabHeaderPresenter [

	| mockDiagramController commandContext headerPresenter headerMorph exampleWindow |
	mockDiagramController := Mock new.
	mockDiagramController stub selectedElements willReturn: #(  ).
	editor canvasPresenter diagramController: mockDiagramController.
	commandContext := editor createCommandContext.
	self assert: commandContext class identicalTo: OPRoassalShapeContext.

	self assert: OPTabHeaderPresenter title equals: 'Tab header'.
	headerPresenter := OPTabHeaderPresenter newApplication: SpApplication defaultApplication.
	headerMorph := headerPresenter build.
	self assert: headerMorph class identicalTo: OPTabLabelMorph.

	exampleWindow := OPTabHeaderPresenter example.
	[
		self assert: exampleWindow class identicalTo: SpWindowPresenter.
		self assert: exampleWindow isOpen description: 'OPTabHeaderPresenter example should open a window' ] ensure: [
		exampleWindow ifNotNil: [ :activeWindow | activeWindow close ] ]
]

{ #category : 'tests' }
OPEditorTest >> testEditorLayoutsSwitching [

	| layoutNames openWindow builder settingNode |
	[
		layoutNames := OPEditor availableLayoutNames.
		self assertCollection: layoutNames hasSameElements: #( 'Palette on left' 'Palette on right' ).
		self assert: OPEditor defaultLayout name equals: 'Palette on left'.

		OPEditor instVarNamed: #currentLayout put: nil.
		self assert: OPEditor currentLayout class identicalTo: OPEditorPaletteLeftLayout.

		openWindow := editor open.
		OPEditor layoutName: 'Palette on right'.
		self assert: OPEditor layoutName equals: 'Palette on right'.
		self assert: editor layout class identicalTo: SpPanedLayout.
		OPEditor setDefaultLayout.
		self assert: OPEditor layoutName equals: 'Palette on left'.

		builder := SettingTreeBuilder new.
		OPEditor settingsOn: builder.
		self assert: builder nodeList size equals: 1.
		settingNode := builder nodeList first.
		self assert: settingNode parentName equals: #openponk.
		self assert: settingNode item name equals: #layoutName ] ensure: [
			openWindow ifNotNil: [ :activeWindow | activeWindow close ].
			OPEditor setDefaultLayout ]
]

{ #category : 'tests' }
OPEditorTest >> testInitializePresentersInstantiatesZoomToolbar [

	self assert: editor zoomToolbar class identicalTo: OPZoomToolbarPresenter.
	self assert: editor zoomToolbar canvasPresenter equals: editor canvasPresenter
]

{ #category : 'tests - layout' }
OPEditorTest >> testResizingWindowWithPaletteOnLeftPreservesPaletteWidth [

	| window leftPaletteWidthBefore leftPaletteWidthAfter |
	[
		OPEditor layoutName: 'Palette on left'.
		editor := (OPEditor on: OPTestPlugin new)
			          application: SpApplication defaultApplication;
			          yourself.
		window := editor open.
		window adapter widget extent: 1000 @ 700.
		window adapter widget fullBounds.
		leftPaletteWidthBefore := editor adapter widget submorphs first width.
		window adapter widget extent: 1400 @ 700.
		window adapter widget fullBounds.
		leftPaletteWidthAfter := editor adapter widget submorphs first width.
		self assert: leftPaletteWidthBefore equals: OPPalette initialWidth.
		self assert: leftPaletteWidthAfter equals: OPPalette initialWidth ] ensure: [
			window ifNotNil: [ :activeWindow | activeWindow close ].
			OPEditor setDefaultLayout ]
]

{ #category : 'tests - layout' }
OPEditorTest >> testResizingWindowWithPaletteOnRightPreservesPaletteWidth [

	| window rightPaletteWidthBefore rightPaletteWidthAfter |
	[
		OPEditor layoutName: 'Palette on right'.
		editor := (OPEditor on: OPTestPlugin new)
			          application: SpApplication defaultApplication;
			          yourself.
		window := editor open.
		window adapter widget extent: 1000 @ 700.
		window adapter widget fullBounds.
		rightPaletteWidthBefore := editor adapter widget submorphs last width.
		window adapter widget extent: 1400 @ 700.
		window adapter widget fullBounds.
		rightPaletteWidthAfter := editor adapter widget submorphs last width.
		self assert: rightPaletteWidthBefore equals: OPPalette initialWidth.
		self assert: rightPaletteWidthAfter equals: OPPalette initialWidth ] ensure: [
			window ifNotNil: [ :activeWindow | activeWindow close ].
			OPEditor setDefaultLayout ]
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
	self assert: initialCamera class identicalTo: OPDiagramCamera.
	self assert: initialCamera scale closeTo: 2.75 precision: 0.001
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
	self assert: editor canvasPresenter zoom closeTo: 1.25 precision: 0.001.
	editor zoomToolbar zoomReset.
	self assert: editor canvasPresenter zoom closeTo: 1.0 precision: 0.001
]
