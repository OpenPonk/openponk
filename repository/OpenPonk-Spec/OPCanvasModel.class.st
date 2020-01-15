"
I am Spec model to embed Roassal2 into DCEditor.
"
Class {
	#name : #OPCanvasModel,
	#superclass : #RoassalModel,
	#instVars : [
		'roassalView',
		'diagramController',
		'lastClickPosition',
		'onZoomChange',
		'lastSelectedFigure'
	],
	#category : 'OpenPonk-Spec-Windows'
}

{ #category : #adding }
OPCanvasModel >> addMenuFor: aFigure [
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
OPCanvasModel >> addMouseEventsFor: aFigure [
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
OPCanvasModel >> attachController: aDiagramController [
	(diagramController := aDiagramController)
		view: roassalView;
		whenFigureAdded: [ :figure | self figureAdded: figure ]
]

{ #category : #private }
OPCanvasModel >> cleanView [
	"roassalView cleanAll is unusable because it breaks (maybe) misused TRRemoveCallbacks"

	roassalView edges copy do: #remove.
	roassalView elements copy do: #remove.
	roassalView canvas shapes copy
		do: [ :each | 
			(each isKindOf: TRCanvasGridShape)
				ifFalse: [ each remove ] ]
]

{ #category : #'private-focus' }
OPCanvasModel >> createCommandContext [
	"Subclases should override it if they provide any selection"

	^ self createCommandContextForSelection: self selectedElements
]

{ #category : #'private-focus' }
OPCanvasModel >> createCommandContextForSelection: selectedItems [
	"simple context has no information about selected items"

	^ OPDiagramFigureContext for: self of: selectedItems
	"	^CmdContactBookPresenterContext for: self of: selectedContacts"
]

{ #category : #accessing }
OPCanvasModel >> diagramController [
	^ diagramController
]

{ #category : #accessing }
OPCanvasModel >> editor [
	^ self owner
]

{ #category : #'private-focus' }
OPCanvasModel >> enableCommanderShortcutsIn: aWidget [

	^ CmdKMDispatcher attachedTo: aWidget withCommandsFrom: self
]

{ #category : #'private-focus' }
OPCanvasModel >> ensureKeyBindingsFor: aWidget [
	super ensureKeyBindingsFor: aWidget.
	^self enableCommanderShortcutsIn: aWidget
]

{ #category : #toolbar }
OPCanvasModel >> exportAsPng [
	FDSaveFileDialog new
		whenSelected: [ :file | self exportCanvasTo: file ];
		extensionFilters: {'Images' -> #(png)};
		defaultName: self editor diagramController model name asFileName , '.png';
		open
]

{ #category : #toolbar }
OPCanvasModel >> exportCanvasTo: aFile [
	| gridShape gridColor |
	gridShape := roassalView canvas shapes
		detect: [ :each | each isKindOf: TRCanvasGridShape ].
	gridColor := gridShape color.
	[ gridShape color: Color transparent.
	OPTRCanvasExporter new
		asPNG;
		canvas: roassalView canvas;
		withoutFixedShapes;
		whole;
		defaultScale;
		oversizedBy: 20 @ 20;
		fileName: aFile;
		export.
	self inform: 'Saved to ' , aFile pathString ]
		ensure: [ gridShape color: gridColor ]
]

{ #category : #adding }
OPCanvasModel >> figureAdded: aFigure [
	"Only elements can be translated, not edges."
	(aFigure isElement)
		ifTrue: [ aFigure translateTo: self lastClickPosition ].
	self addMouseEventsFor: aFigure.
	self addMenuFor: aFigure.
	self signalUpdate
]

{ #category : #initialization }
OPCanvasModel >> initialize [
	super initialize.
	onZoomChange := [ :value |  ].
	self
		script: [ :view :canvas | 
			roassalView := view.
			self initializeView: view ]
]

{ #category : #initialization }
OPCanvasModel >> initializeView: aView [
	aView when: TRMouseLeftClick do: [ :event | self viewClicked: event ].
	aView when: TRMouseRightClick do: [ :event | self viewContextClicked: event ].
	aView canvas theme: TRWhiteTheme new.
	aView @ (OPRTSelectableView new candidatesBlock: [ diagramController selectableFigures ]).
	aView @ (RTZoomableView new min: 0.05 max: 4).
	aView @ (OPRTGridView2 new gridSize: 20).
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
OPCanvasModel >> lastClickPosition [
	^ lastClickPosition ifNil: [ 0 @ 0 ]
]

{ #category : #events }
OPCanvasModel >> lastClickPosition: aPoint [
	lastClickPosition := aPoint
]

{ #category : #accessing }
OPCanvasModel >> lastSelectedFigure [
	^ lastSelectedFigure
]

{ #category : #accessing }
OPCanvasModel >> lastSelectedFigure: aFigure [
	lastSelectedFigure := aFigure
]

{ #category : #private }
OPCanvasModel >> loadElementsFromController [
	self deprecated: 'Control reloading from Controller, not Canvas'.
	[ World activeHand showTemporaryCursor: Cursor wait.
	World doOneCycle.
	diagramController rebuild.
	diagramController applyDefaultLayout ]
		ensure: [ World activeHand showTemporaryCursor: nil ]
]

{ #category : #signalling }
OPCanvasModel >> reloadView [
	self deprecated: 'Control reloading from Controller, not Canvas'.
	self cleanView.
	diagramController ifNotNil: [ self loadElementsFromController ].
	diagramController ifNotNil: [ diagramController updateView ]
]

{ #category : #accessing }
OPCanvasModel >> roassalView [
	^ roassalView
]

{ #category : #accessing }
OPCanvasModel >> selectedElements [
	roassalView attributes
		at: OPRTSelectableView
		ifPresent: [ :els | els ifNotEmpty: [ ^ els ] ].
	^ self lastSelectedFigure ifNil: [ {} ] ifNotNil: [ {self lastSelectedFigure} ]
]

{ #category : #'as yet unclassified' }
OPCanvasModel >> showAllFigures [
	roassalView canvas focusOnCenterScaled
]

{ #category : #signalling }
OPCanvasModel >> signalUpdate [
	roassalView signalUpdate
]

{ #category : #'selection handling' }
OPCanvasModel >> viewClicked: anEvent [
	self lastClickPosition: anEvent position.
	self diagramController selectView
]

{ #category : #'selection handling' }
OPCanvasModel >> viewContextClicked: anEvent [
	(OPPragmaPluginMenuBuilder cachedPragmaKeyword: #opCanvasContextMenu: model: self) menuSpec
		asMenuMorph popUpInWorld
]

{ #category : #accessing }
OPCanvasModel >> whenZoomChanged: aOneArgBlock [
	onZoomChange := aOneArgBlock
]

{ #category : #accessing }
OPCanvasModel >> workbench [
	^ self editor workbench
]

{ #category : #accessing }
OPCanvasModel >> zoom [
	"1: default zoom (it should be 1.0001, but who cares)
	2: zoomed in to 200%"

	^ roassalView canvas camera scale
]

{ #category : #accessing }
OPCanvasModel >> zoom: aScale [
	"1: default zoom (it should be 1.0001, but who cares)
	2: zoomed in to 200%"

	(aScale between: 0.05 and: 4)
		ifFalse: [ ^ self ].
	roassalView canvas camera scale: aScale.
	roassalView signalUpdate
]
