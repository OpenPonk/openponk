"
I am Spec model to embed Roassal2 into DCEditor.
"
Class {
	#name : #OPCanvasPresenter,
	#superclass : #SpRoassal2Presenter,
	#instVars : [
		'roassalView',
		'diagramController',
		'lastClickPosition',
		'onZoomChange',
		'lastSelectedFigure'
	],
	#category : #'OpenPonk-Spec-Windows'
}

{ #category : #adding }
OPCanvasPresenter >> addMenuFor: aFigure [
	aFigure
		when: TRMouseRightClick
		do: [ :event | 
			| menu |
			self lastClickPosition: event position.
			self diagramController selectFigure: event element.
			self lastSelectedFigure: event element.
			menu := CmdContextMenuActivation
				buildContextMenuFor: self
				inContext: (OPDiagramFigureContext for: self of: self selectedElements).
			menu popUpInWorld ]
]

{ #category : #adding }
OPCanvasPresenter >> addMouseEventsFor: aFigure [
	aFigure
		when: TRMouseDoubleLeftClick
		do: [ :event | 
			self lastClickPosition: event position.
			self diagramController doubleClickFigure: event element ].
	aFigure
		when: TRMouseLeftClick
		do: [ :event | 
			self lastClickPosition: event position.
			self diagramController selectFigure: event element.
			self lastSelectedFigure: event element ].
	aFigure
		when: TRMouseRightClick
		do: [ :event | 
			self lastClickPosition: event position.
			self diagramController selectFigure: event element.
			self lastSelectedFigure: event element ].
	aFigure
		when: TRMouseEnter
		do: [ :event | 
			self lastClickPosition: event position.
			self diagramController hoverFigure: event element ].
	aFigure
		when: TRMouseLeave
		do: [ :event | 
			self lastClickPosition: event position.
			self diagramController hoverView ]
]

{ #category : #accessing }
OPCanvasPresenter >> attachController: aDiagramController [

	(diagramController := aDiagramController)
		view: roassalView;
		whenFigureAdded: [ :figure | self figureAdded: figure ];
		whenAllDeselectedDo: [ self lastSelectedFigure: nil ]
]

{ #category : #private }
OPCanvasPresenter >> cleanView [

	"roassalView cleanAll is unusable because it breaks (maybe) misused TRRemoveCallbacks"

	roassalView edges copy do: #remove.
	roassalView elements copy do: #remove.
	roassalView canvas shapes copy do: [ :each | 
		(each isKindOf: TRCanvasGridShape) ifFalse: [ each remove ] ]
]

{ #category : #'private-focus' }
OPCanvasPresenter >> createCommandContext [
	"Subclases should override it if they provide any selection"

	^ self createCommandContextForSelection: self selectedElements
]

{ #category : #'private-focus' }
OPCanvasPresenter >> createCommandContextForSelection: selectedItems [
	"simple context has no information about selected items"

	^ OPDiagramFigureContext for: self of: selectedItems
	"	^CmdContactBookPresenterContext for: self of: selectedContacts"
]

{ #category : #accessing }
OPCanvasPresenter >> diagramController [
	^ diagramController
]

{ #category : #accessing }
OPCanvasPresenter >> editor [
	^ self owner
]

{ #category : #'private-focus' }
OPCanvasPresenter >> ensureKeyBindingsFor: aWidget [

	self flag: 'Does not work in P11'.
	super ensureKeyBindingsFor: aWidget.
	^ self enableCommanderShortcutsIn: aWidget
]

{ #category : #toolbar }
OPCanvasPresenter >> exportAsPng [

	self flag: 'default name not supported in file browser'.
	OPExportImageDialog new
		title: 'Choose a PNG file to export the diagram';
		okAction: [ :file :zoom | 
			| acceptFile |
			acceptFile := true.
			self ifNonAsciiCharactersIn: file do: [ acceptFile := false ].
			acceptFile
				ifTrue: [ self exportCanvasToPng: file zoom: zoom ]
				ifFalse: [ self exportAsPng ] ];
		extensions: #( png ) named: 'PNG images';
		open
]

{ #category : #toolbar }
OPCanvasPresenter >> exportAsSvg [

	self flag: 'default name not supported in file browser'.
	StFBSaveFileDialog new
		title: 'Choose a SVG file to export the diagram';
		okAction: [ :file | self exportCanvasToSvg: file ];
		extensions: #( svg ) named: 'SVG images';
		"defaultName:
			self editor diagramController model name asFileName , '.svg';"
			open
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToPng: aFile [

	self exportCanvasToPng: aFile silently: false
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToPng: aFile silently: aSilentlyBoolean [

	self
		exportCanvasToPng: aFile
		zoom: TRCamera basicNew defaultCameraScale
		silently: aSilentlyBoolean
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToPng: aFileReference zoom: aNumber [

	self exportCanvasToPng: aFileReference zoom: aNumber silently: false
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToPng: aFileReference zoom: aNumber silently: aSilentlyBoolean [

	| gridShape gridColor zoom view approxResolution jobBlock |
	self ifNonAsciiCharactersIn: aFileReference do: [ ^ self ].
	view := roassalView.
	approxResolution := aNumber * aNumber
	                    * view canvas encompassingRectangle area.
	zoom := (aNumber squared * view canvas encompassingRectangle area
	         > 500000000
		         ifTrue: [ 
			         (500000000 / view canvas encompassingRectangle area) sqrt 
				         roundDownTo: 0.01 ]
		         ifFalse: [ aNumber ]) max: 0.01.

	(aSilentlyBoolean not and: [ (aNumber - zoom) abs > 0.011 ]) ifTrue: [ 
		GrowlMorph
			openWithLabel: 'Warning'
			contents: 'Export zoom was reduced to '
				, (zoom * 100 printShowingDecimalPlaces: 0)
				, ' % zoom due to technical restrictions.'
			backgroundColor: GrowlMorph theme warningBackgroundColor
			labelColor: GrowlMorph theme textColor ].

	zoom = 1 ifTrue: [ zoom := 1.01 ].

	gridShape := view canvas shapes detect: [ :each | 
		             each isKindOf: TRCanvasGridShape ].
	gridColor := gridShape color.
	self diagramController deselectAll.

	jobBlock := [ :job | 
	            approxResolution := zoom * zoom
	                                *
	                                view canvas encompassingRectangle
		                                area.
	            job title:
		            'Exporting diagram - might take '
		            , (approxResolution > 120000000
				             ifTrue: [ 'tens of seconds' ]
				             ifFalse: [ 
					             approxResolution > 1200000
						             ifTrue: [ 'several seconds' ]
						             ifFalse: [ 'a few seconds' ] ]).
	            [ 
	            gridShape color: Color transparent.
	            (zoom - view canvas camera scale) abs >= 0.01 ifTrue: [ 
		            view := view veryDeepCopy.
		            view canvas camera scale: zoom.
		            job progress: 0.2 ].

	            RTPNGExporter new
		            builder: view;
		            withScale;
		            fileName: aFileReference pathString;
		            exportToFile ] ensure: [ 
		            job progress: 0.8.
		            gridShape color: gridColor.
		            view signalUpdate ] ].

	aSilentlyBoolean ifTrue: [ ^ jobBlock value: Job new ].
	jobBlock asJob run.

	UIManager default
		inform: (String streamContents: [ :s | 
				 s << 'Image saved to ' << aFileReference pathString.
				 s
					 cr;
					 cr.
				 s << 'Click to open location' ])
		actionOnClick: [ aFileReference openInOSFileBrowser ]
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToSvg: aFileReference [

	self exportCanvasToSvg: aFileReference silently: false
]

{ #category : #toolbar }
OPCanvasPresenter >> exportCanvasToSvg: aFileReference silently: aSilentlyBoolean [

	| view amountOfElements jobBlock |
	view := roassalView.

	self diagramController deselectAll.

	jobBlock := [ :job | 
	            amountOfElements := view elements size.
	            job title:
		            'Exporting diagram - might take '
		            , (amountOfElements > 5000
				             ifTrue: [ 'tens of seconds' ]
				             ifFalse: [ 
					             amountOfElements > 500
						             ifTrue: [ 'several seconds' ]
						             ifFalse: [ 'a few seconds' ] ]).

	            RTSVGExporter
		            exportViewAsSVG: view
		            filename: aFileReference ].

	aSilentlyBoolean ifTrue: [ ^ jobBlock value: Job new ].
	jobBlock asJob run.

	UIManager default
		inform: (String streamContents: [ :s | 
				 s << 'Image saved to ' << aFileReference pathString.
				 s
					 cr;
					 cr.
				 s << 'Click to open location' ])
		actionOnClick: [ aFileReference openInOSFileBrowser ]
]

{ #category : #adding }
OPCanvasPresenter >> figureAdded: aFigure [
	"Only elements can be translated, not edges."
	(aFigure isElement)
		ifTrue: [ aFigure translateTo: self lastClickPosition ].
	self addMouseEventsFor: aFigure.
	self addMenuFor: aFigure.
	self signalUpdate
]

{ #category : #toolbar }
OPCanvasPresenter >> ifNonAsciiCharactersIn: aFileReference do: aBlock [

	| placesWithNonAscii |
	placesWithNonAscii := OrderedCollection new.
	aFileReference basename isAsciiString ifFalse: [ 
		placesWithNonAscii add: 'file name' ].
	aFileReference parent absolutePath pathString isAsciiString ifFalse: [ 
		placesWithNonAscii add: 'file path' ].
	placesWithNonAscii ifEmpty: [ ^ self ].
	(GrowlMorph
		 label: (String streamContents: [ :s | 
					  s << 'PNG exporter error: Non-ASCII characters in '.
					  placesWithNonAscii asStringOn: s delimiter: ' and ' ])
		 contents: (String streamContents: [ :s | 
					  s
					  <<
						  'Due to a bug, PNG exporter does not support non-ASCII characters anywhere in file paths. Please export the image to a different '.
					  placesWithNonAscii asStringOn: s delimiter: ' and ' ]))
		vanishDelay: 15 seconds;
		backgroundColor: GrowlMorph theme dangerBackgroundColor;
		openInWorld.
	aBlock value
]

{ #category : #initialization }
OPCanvasPresenter >> initialize [

	super initialize.
	onZoomChange := [ :value |  ].
	self script: [ :view :canvas | 
		roassalView := view.
		self initializeView: view ]
]

{ #category : #initialization }
OPCanvasPresenter >> initializeView: aView [
	aView when: TRMouseLeftClick do: [ :event | self viewClicked: event ].
	aView
		when: TRMouseRightClick
		do: [ :event | self viewContextClicked: event ].
	aView canvas theme: TRWhiteTheme new.
	aView
		@
			(OPRTSelectableView new
				candidatesBlock: [ diagramController selectableFigures ]).
	aView @ (RTZoomableView new min: 0.05 max: 4).
	aView @ (RTGridView new gridSize: 20).
	^ aView canvas camera
		addCallback:
			(TRCameraScaleCallback
				block: [ :newScale | 
					onZoomChange
						value:
							(newScale < 1
								ifTrue: [ '   ' ]
								ifFalse: [ '' ]) , (newScale * 100) rounded asString , '%'.
					self editor zoomLabel
						label:
							(newScale < 1
								ifTrue: [ '   ' ]
								ifFalse: [ '' ]) , (newScale * 100) rounded asString , '%' ])
]

{ #category : #events }
OPCanvasPresenter >> lastClickPosition [
	^ lastClickPosition ifNil: [ 0 @ 0 ]
]

{ #category : #events }
OPCanvasPresenter >> lastClickPosition: aPoint [
	lastClickPosition := aPoint
]

{ #category : #accessing }
OPCanvasPresenter >> lastSelectedFigure [
	^ lastSelectedFigure
]

{ #category : #accessing }
OPCanvasPresenter >> lastSelectedFigure: aFigure [
	lastSelectedFigure := aFigure
]

{ #category : #private }
OPCanvasPresenter >> loadElementsFromController [

	self deprecated: 'Control reloading from Controller, not Canvas'.
	[ 
	self currentWorld activeHand showTemporaryCursor: Cursor wait.
	self currentWorld doOneCycle.
	diagramController rebuild.
	diagramController applyDefaultLayout ] ensure: [ 
		self currentWorld activeHand showTemporaryCursor: nil ]
]

{ #category : #accessing }
OPCanvasPresenter >> model [
	^ diagramController model
]

{ #category : #signalling }
OPCanvasPresenter >> reloadView [
	self deprecated: 'Control reloading from Controller, not Canvas'.
	self cleanView.
	diagramController ifNotNil: [ self loadElementsFromController ].
	diagramController ifNotNil: [ diagramController updateView ]
]

{ #category : #accessing }
OPCanvasPresenter >> roassalView [
	^ roassalView
]

{ #category : #accessing }
OPCanvasPresenter >> selectedElements [

	roassalView attributes
		at: OPRTSelectableView
		ifPresent: [ :els | els ifNotEmpty: [ ^ els ] ].
	^ self lastSelectedFigure
		  ifNil: [ {  } ]
		  ifNotNil: [ { self lastSelectedFigure } ]
]

{ #category : #'as yet unclassified' }
OPCanvasPresenter >> showAllFigures [

	roassalView elements
		ifEmpty: [ roassalView canvas camera scale: 1 ]
		ifNotEmpty: [ roassalView canvas focusOnCenterScaled ]
]

{ #category : #signalling }
OPCanvasPresenter >> signalUpdate [
	roassalView signalUpdate
]

{ #category : #'selection handling' }
OPCanvasPresenter >> viewClicked: anEvent [
	self lastClickPosition: anEvent position.
	self diagramController selectView
]

{ #category : #'selection handling' }
OPCanvasPresenter >> viewContextClicked: anEvent [

	(OPPragmaPluginMenuBuilder
		 pragmaKeyword: #opCanvasContextMenu:
		 model: self) menuSpec asMenuMorph popUpInWorld
]

{ #category : #accessing }
OPCanvasPresenter >> whenZoomChanged: aOneArgBlock [
	onZoomChange := aOneArgBlock
]

{ #category : #accessing }
OPCanvasPresenter >> workbench [
	^ self editor workbench
]

{ #category : #accessing }
OPCanvasPresenter >> zoom [
	"1: default zoom (it should be 1.0001, but who cares)
	2: zoomed in to 200%"

	^ roassalView canvas camera scale
]

{ #category : #accessing }
OPCanvasPresenter >> zoom: aScale [
	"1: default zoom (it should be 1.0001, but who cares)
	2: zoomed in to 200%"

	(aScale between: 0.05 and: 4)
		ifFalse: [ ^ self ].
	roassalView canvas camera scale: aScale.
	roassalView signalUpdate
]
