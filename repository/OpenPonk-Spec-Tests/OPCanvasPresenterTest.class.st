Class {
	#name : 'OPCanvasPresenterTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests-Windows',
	#package : 'OpenPonk-Spec-Tests',
	#tag : 'Windows'
}

{ #category : 'tests' }
OPCanvasPresenterTest >> testCommandContextAndDefaultExportFolderAndZoom [
	| project container testCanvas diagram projectController diagramController workbench presenter diagramFile zoomed extentChanged |
	project := OPProject new.
	container := OPTestContainerModel new.
	project addModel: container.
	testCanvas := RSCanvas new.
	diagram := OPOpenPonkDiagram forModelElement: container.
	diagram canvas: testCanvas.
	project addDiagram: diagram.
	projectController := OPProjectController forProject: project.
	workbench := OPWorkbench new.
	workbench instVarNamed: #projectController put: projectController.
	projectController workbench: workbench.
	diagramController := OPTestDiagramController new.
	projectController addDiagramController: diagramController.
	presenter := OPCanvasPresenter new canvas: testCanvas; yourself.
	diagramController
		model: container;
		diagramElement: diagram;
		canvasPresenter: presenter.
	presenter attachController: diagramController.
	diagramController showInDiagramModel: (container add: OPTestEntityModel new).
	diagramFile := FileSystem workingDirectory / 'dummy.opp'.
	project storageFile: diagramFile.
	presenter owner: (OPEditor new instVarNamed: #workbench put: workbench; yourself).
	self assert: presenter defaultExportFolder equals: FileSystem workingDirectory.
	self assert: presenter createCommandContext class equals: OPRoassalShapeContext.
	zoomed := false.
	extentChanged := false.
	presenter whenZoomChanged: [ :evt | zoomed := true ].
	presenter whenExtentChangedDo: [ :evt | extentChanged := true ].
	presenter zoom: 1.5.
	self assert: presenter zoom closeTo: 1.5.
	self
		assert: zoomed
		description: 'Changing zoom scale should invoke whenZoomChanged callback'.
	presenter zoom: 100.
	self assert: presenter zoom closeTo: 1.5.
	presenter zoomToFit.
	presenter signalUpdate
]

{ #category : 'tests' }
OPCanvasPresenterTest >> testDefaultExportFileNameUsesSanitizer [
	| canvasPresenter diagramController viewModel |
	canvasPresenter := OPCanvasPresenter new.
	diagramController := Mock new.
	viewModel := Mock new.
	canvasPresenter diagramController: diagramController.
	diagramController stub viewModel willReturn: viewModel.
	viewModel stub nameOfModel willReturn: 'My Diagram / Invalid * Name'.

	self
		assert: (canvasPresenter defaultExportFileNameWithExtension: 'svg')
		equals: (FileNameSanitizer sanitize: 'My Diagram / Invalid * Name') , '.svg'
]

{ #category : 'tests' }
OPCanvasPresenterTest >> testExportAsPdfPngAndSvg [
	| editor canvasPresenter project container diagram projectController diagramController entity tempPdfFile tempPngFile tempDirectPngFile tempSvgFile mockSavePresenter mockImageDialog storedPdfAction storedPngAction storedSvgAction |
	storedPdfAction := nil.
	storedPngAction := nil.
	storedSvgAction := nil.

	editor := OPEditor new.
	canvasPresenter := editor canvasPresenter.
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
		diagramElement: diagram.
	canvasPresenter attachController: diagramController.
	entity := OPTestEntityModel new.
	container add: entity.
	diagramController showInDiagramModel: entity.

	tempPdfFile := FileLocator temp / ('openponk-test-' , UUID new asString , '.pdf').
	tempPngFile := FileLocator temp / ('openponk-test-' , UUID new asString , '.png').
	tempDirectPngFile := FileLocator temp / ('openponk-test-direct-' , UUID new asString , '.png').
	tempSvgFile := FileLocator temp / ('openponk-test-' , UUID new asString , '.svg').

	[
		canvasPresenter exportAsPng: tempDirectPngFile.
		self assert: tempDirectPngFile exists description: 'exportAsPng: must write a PNG file'.

		mockSavePresenter := Mock new.
		StSaveFilePresenter stub new willReturn: mockSavePresenter.
		mockSavePresenter stub title: Any.
		mockSavePresenter stub nameText: Any.
		mockSavePresenter stub defaultFolder: Any.
		mockSavePresenter stub extensions: Any named: Any.
		(mockSavePresenter stub okAction: Any) will: [ :action | storedPdfAction := action ].
		mockSavePresenter stub openModal will: [ storedPdfAction value: tempPdfFile ].
		canvasPresenter exportAsPdf.
		self assert: tempPdfFile exists description: 'exportAsPdf must export a PDF file on dialog confirmation'.

		(mockSavePresenter stub okAction: Any) will: [ :action | storedSvgAction := action ].
		mockSavePresenter stub openModal will: [ storedSvgAction value: tempSvgFile ].
		canvasPresenter exportAsSvg.
		self assert: tempSvgFile exists description: 'exportAsSvg must export an SVG file on dialog confirmation'.

		mockImageDialog := Mock new.
		OPExportImageDialog stub new willReturn: mockImageDialog.
		mockImageDialog stub title: Any.
		mockImageDialog stub nameText: Any.
		mockImageDialog stub defaultFolder: Any.
		mockImageDialog stub extensions: Any named: Any.
		(mockImageDialog stub okAction: Any) will: [ :action | storedPngAction := action ].
		mockImageDialog stub openModal will: [ storedPngAction value: tempPngFile value: 1.5 ].
		canvasPresenter exportAsPng.
		self assert: tempPngFile exists description: 'exportAsPng must export a PNG file on dialog confirmation'
	] ensure: [
		tempPdfFile ensureDelete.
		tempPngFile ensureDelete.
		tempDirectPngFile ensureDelete.
		tempSvgFile ensureDelete ]
]

{ #category : 'tests' }
OPCanvasPresenterTest >> testExportWithCleanCanvasUnhighlightsAndRestoresSelectionAndHandles [
	| canvasPresenter canvas shape resizable selectable mockController originalBorder highlightedBorder initialHandles wasExported |
	canvasPresenter := OPCanvasPresenter new.
	canvas := canvasPresenter canvas.

	mockController := Mock new.
	canvasPresenter diagramController: mockController.
	mockController stub canvasPresenter willReturn: canvasPresenter.
	mockController stub canvas willReturn: canvas.
	mockController stub selectedShapes: Any onPosition: Any.

	shape := RSBox new
		size: 80;
		color: Color white;
		borderColor: Color black;
		yourself.
	canvas add: shape.
	shape @ OPRSSelectable.
	shape @ OPRSResizable.

	selectable := shape propertyAt: OPRSSelectable.
	selectable highlightBorderColor: Color blue.
	resizable := shape propertyAt: OPRSResizable.
	originalBorder := shape border copy.

	(canvas propertyAt: OPRSSelectableCanvas)
		selectShapes: (RSGroup with: shape)
		byEvent: (RSMouseClick new canvas: canvas; position: shape position; yourself).
	resizable showHandles: (OPRSSelectionEndEvent new
		canvas: canvas;
		selectedShapes: (RSGroup with: shape);
		originalEvent: (RSMouseClick new canvas: canvas; position: shape position; yourself);
		yourself).
	selectable doHighlightShapes: { shape }.

	highlightedBorder := shape border copy.
	self
		assert: highlightedBorder color ~= originalBorder color
		description: 'Initial setup: shape must be highlighted before export'.
	self
		assert: resizable handles isNotEmpty
		description: 'Initial setup: resizable handles must be present before export'.

	initialHandles := resizable handles copy.
	self
		assert: (canvas shapes includesAll: initialHandles)
		description: 'Initial setup: canvas shapes must contain resizable handles'.

	mockController stub selectedElements willReturn: (RSGroup with: shape).
	(mockController stub withoutSelectionDo: Any) will: [ :exportBlock |
		| previousElements |
		previousElements := RSGroup with: shape.
		(shape propertyAt: OPRSSelectable) unhighlightRecordedShapes: canvas.
		(canvas propertyAt: OPRSSelectableCanvas)
			selectShapes: RSGroup new
			byEvent: (RSMouseClick new canvas: canvas; position: 0 @ 0; yourself).
		[ exportBlock value ] ensure: [
			(shape propertyAt: OPRSSelectable) doHighlightShapes: previousElements.
			(canvas propertyAt: OPRSSelectableCanvas)
				selectShapes: previousElements
				byEvent: (RSMouseClick new canvas: canvas; position: shape position; yourself) ] ].

	wasExported := false.
	canvasPresenter exportWithCleanCanvasDo: [
		wasExported := true.
		self
			assert: shape border color = originalBorder color
			description: ('During export: border color must be {1}, but was {2}'
				format: { originalBorder color asString . shape border color asString }).
		self
			assert: (resizable handles isNil or: [ resizable handles isEmpty ])
			description: ('During export: resizable handles must be nil/empty, but size was {1}'
				format: { resizable handles ifNil: [ 0 ] ifNotNil: [ :h | h size ] }).
		self
			deny: (canvas shapes includesAny: initialHandles)
			description: 'During export: canvas must not contain any initial handle shapes' ].

	self
		assert: wasExported
		description: 'Export block was not executed'.
	self
		assert: shape border color = highlightedBorder color
		description: ('After export: border color must be restored to {1}, but was {2}'
				format: { highlightedBorder color asString . shape border color asString }).
	self
		assert: (resizable handles isNotNil and: [ resizable handles isNotEmpty ])
		description: ('After export: resizable handles must be restored, but size was {1}'
				format: { resizable handles ifNil: [ 0 ] ifNotNil: [ :h | h size ] }).
	self
		assert: (canvas shapes includesAll: resizable handles)
		description: 'After export: canvas shapes must contain all restored resizable handles'.
	mockController should receive withoutSelectionDo: Any
]

{ #category : 'tests' }
OPCanvasPresenterTest >> testStandaloneCanvasFallbacksAndCallbacks [
	| editor canvasPresenter window extentChanged project container diagram projectController diagramController entity standaloneExecuted |
	editor := OPEditor new.
	canvasPresenter := editor canvasPresenter.
	window := editor open.
	[
		self assert: canvasPresenter workbench isNil description: 'Editor without assigned workbench should answer nil workbench'.
		self assert: canvasPresenter defaultExportFolder equals: FileSystem workingDirectory.
		self assert: (canvasPresenter defaultExportFileNameWithExtension: 'pdf') equals: 'diagram.pdf'.

		extentChanged := false.
		canvasPresenter whenExtentChangedDo: [ :event | extentChanged := true ].
		canvasPresenter canvas announce: (RSExtentChangedEvent new canvas: canvasPresenter canvas; yourself).
		self assert: extentChanged description: 'Canvas extent change should invoke whenExtentChangedDo: callback'.

		canvasPresenter zoom: 2.0.
		self assert: canvasPresenter zoom closeTo: 2.0.
		canvasPresenter zoomToFit.
		self assert: canvasPresenter zoom closeTo: 1.0.

		standaloneExecuted := false.
		canvasPresenter exportWithCleanCanvasDo: [ standaloneExecuted := true ].
		self assert: standaloneExecuted description: 'exportWithCleanCanvasDo: must execute block directly when diagramController is nil'.

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
			diagramElement: diagram.
		canvasPresenter attachController: diagramController.
		entity := OPTestEntityModel new.
		container add: entity.
		diagramController showInDiagramModel: entity.

		self assert: canvasPresenter model identicalTo: container.
		self assert: (canvasPresenter defaultExportFileNameWithExtension: 'pdf') equals: 'container.pdf'.
		container name: '   '.
		self assert: (canvasPresenter defaultExportFileNameWithExtension: 'pdf') equals: 'diagram.pdf'
	] ensure: [ window ifNotNil: [ window close ] ]
]
