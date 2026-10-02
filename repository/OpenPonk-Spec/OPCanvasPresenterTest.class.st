Class {
	#name : 'OPCanvasPresenterTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Spec-Tests',
	#package : 'OpenPonk-Spec',
	#tag : 'Tests'
}

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
