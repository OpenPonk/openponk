"
A DCDiagramController is the parent class to controller classes that control whole diagrams. It (its decendant) creates a palette / menu  for specific diagram. It also handles the changes in diagram, e.g. removal of element. 
"
Class {
	#name : #OPDiagramController,
	#superclass : #OPController,
	#instVars : [
		'announcer',
		'controllers',
		'editor',
		'figureAdded',
		'plugin',
		'autosaveManager',
		'figureToControllerCache',
		'modelToControllerCache',
		'workbenchAnnouncer',
		'layouter',
		'figuresBeingAdded',
		'controllerFactory',
		'lastClickPosition',
		'lastSelectionPosition',
		'canvasPresenter'
	],
	#category : #'OpenPonk-Core-Controllers'
}

{ #category : #deprecated }
OPDiagramController >> addAllElements [

	self
		deprecated: 'Use #showAllElements instead.'
		transformWith:
		'`@receiver addAllElements' -> '`@receiver showAllElements'.
	^ self showAllElements
]

{ #category : #adding }
OPDiagramController >> addCommonElementsFromDiagram [
	diagram commonElements do: [ :each | self showInDiagramModel: each ]
]

{ #category : #'controllers management' }
OPDiagramController >> addController: aController [
	aController diagramController: self.
	self controllers add: aController
]

{ #category : #deprecated }
OPDiagramController >> addModelElement: aModelElement [
	| controller figure |
	self deprecated: 'Use createModelIn:andShowInDiagram: instead.'.
"	self controllers detect: [ :ctrl | ctrl model = aModelElement ] ifFound: [ ^ self ].
	(self model has: aModelElement)
		ifFalse: [ self model add: aModelElement ].
	controller := self createController: aModelElement.
	controller diagramController: self.
	self controllers add: controller.
	(controller isKindOf: OPRelationshipController)
		ifTrue: [ 
			| fromModel toModel fromCtrl toCtrl |
			fromModel := aModelElement source.
			toModel := aModelElement target.
			fromCtrl := self controllers detect: [ :ctrl | ctrl model = fromModel ] ifNone: [ self addModelElement: fromModel ].
			toCtrl := self controllers detect: [ :ctrl | ctrl model = toModel ] ifNone: [ self addModelElement: toModel ].
			controller
				source: fromCtrl;
				target: toCtrl ].
	controller registerModelEvents: controller model.
	figure := controller figure.
	figure view ifNil: [ figure renderIn: self view ].
	self diagramController figureAdded: figure.
	^ controller"
]

{ #category : #accessing }
OPDiagramController >> addMouseEventsFor: aFigure [

	aFigure
		when: RSMouseRightClick
		do: [ :event | self figureContextClicked: event ].
	aFigure
		when: RSMouseEnter
		do: [ :event | self hoverRoassalShape: event shape ]
]

{ #category : #accessing }
OPDiagramController >> addedFigureFor: aController [

	| figure |
	(figuresBeingAdded includes: aController)
		ifFalse: [ 
			self traceCr:
				'DiagramController>>#addedFigureFor: added figure not previously marked as being added' ]
		ifTrue: [ figuresBeingAdded remove: aController ].

	figure := aController roassalShape.

	figure isNode ifTrue: [ 
		lastSelectionPosition ifNotNil: [ 
			figure translateTo: lastSelectionPosition ] ].
	self addMouseEventsFor: figure.

	figuresBeingAdded ifEmpty: [ self updateCanvas ].
	figure signalUpdate.

	^ figure
]

{ #category : #accessing }
OPDiagramController >> addingFigureFor: aController [

	(figuresBeingAdded includes: aController) ifTrue: [ 
		self notify: 'Same controller is already being added' ].
	figuresBeingAdded add: aController
]

{ #category : #rendering }
OPDiagramController >> allShowableElements [
	"Should return all elements that could be directly hidden on diagram"

	^ (Set with: model) , self elementsToShowInside
		, self diagram commonElements
]

{ #category : #'as yet unclassified' }
OPDiagramController >> allVisibleShowableElements [
	"Should return all elements that could be directly hidden on diagram but are currently shown"

	^ self controllers collect: [ :each | each model ]
]

{ #category : #accessing }
OPDiagramController >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : #userinterface }
OPDiagramController >> applyDefaultLayout [
	self layouter defaultLayout
]

{ #category : #accessing }
OPDiagramController >> autosaveManager [
	^ autosaveManager
		ifNil: [ autosaveManager := OPAutosaveManager
				on: self plugin singleStringSerializer ]
]

{ #category : #'controllers management' }
OPDiagramController >> cachedControllerForModel: aModel [

	^ self cachedControllerForModel: aModel ifNone: [ 
		  self controllers errorNotFound:
			  'Controller for ' , aModel printString ]
]

{ #category : #'controllers management' }
OPDiagramController >> cachedControllerForModel: aModel ifFound: aFoundBlock [

	^ self
		  cachedControllerForModel: aModel
		  ifFound: aFoundBlock
		  ifNone: [ nil ]
]

{ #category : #'controllers management' }
OPDiagramController >> cachedControllerForModel: aModel ifFound: aFoundBlock ifNone: aNoneBlock [

	| ctrl |
	modelToControllerCache ifNil: [ 
		modelToControllerCache := Dictionary new.
		self controllers do: [ :each | 
			modelToControllerCache at: each model put: each ] ].
	ctrl := modelToControllerCache at: aModel ifPresent: #yourself.
	(self controllers includes: ctrl) ifTrue: [ 
		^ aFoundBlock value: ctrl ].
	^ self controllers
		  detect: [ :fresh | fresh model = aModel ]
		  ifFound: [ :found | 
			  modelToControllerCache at: aModel put: found.
			  aFoundBlock cull: found ]
		  ifNone: aNoneBlock
]

{ #category : #'controllers management' }
OPDiagramController >> cachedControllerForModel: aModel ifNone: aNoneBlock [

	^ self
		  cachedControllerForModel: aModel
		  ifFound: [ :ctrl | ctrl ]
		  ifNone: aNoneBlock
]

{ #category : #'controllers management' }
OPDiagramController >> cachedControllerForRoassalShape: aFigure [

	| ctrl |
	figureToControllerCache ifNil: [ 
		figureToControllerCache := Dictionary new.
		self controllers do: [ :each | 
			figureToControllerCache at: each roassalShape put: each ] ].
	ctrl := figureToControllerCache at: aFigure ifPresent: #yourself.
	(self controllers includes: ctrl) ifTrue: [ ^ ctrl ].
	ctrl := self controllers detect: [ :fresh | fresh roassalShape = aFigure ].
	figureToControllerCache at: aFigure put: ctrl.
	^ ctrl
]

{ #category : #'controllers management' }
OPDiagramController >> cachedControllerForRoassalShape: aFigure ifNone: aBlock [

	| ctrl |
	figureToControllerCache ifNil: [ 
		figureToControllerCache := Dictionary new.
		self controllers do: [ :each | 
			figureToControllerCache at: each figure put: each ] ].
	ctrl := figureToControllerCache at: aFigure ifPresent: #yourself.
	(self controllers includes: ctrl) ifTrue: [ ^ ctrl ].
	ctrl := self controllers
		        detect: [ :fresh | fresh roassalShape = aFigure ]
		        ifNone: [ ^ aBlock value ].
	figureToControllerCache at: aFigure put: ctrl.
	^ ctrl
]

{ #category : #connecting }
OPDiagramController >> canBeTargetFor: aController [
	^ (aController isKindOf: OPCommonElementController)
		and: [ aController class ~= OPCommonElementController ]
]

{ #category : #accessing }
OPDiagramController >> canvas [
	^ canvasPresenter canvas
]

{ #category : #accessing }
OPDiagramController >> canvasPresenter [

	^ canvasPresenter
]

{ #category : #accessing }
OPDiagramController >> canvasPresenter: aCanvasPresenter [

	canvasPresenter := aCanvasPresenter.
	self addMouseEventsFor: canvasPresenter canvas
]

{ #category : #rebuilding }
OPDiagramController >> cleanCanvas [

	self editor canvasPresenter cleanCanvas
]

{ #category : #rebuilding }
OPDiagramController >> cleanView [

	self
		deprecated: 'Use #cleanCanvas instead.'
		transformWith: '`@receiver cleanView' -> '`@receiver cleanCanvas'.
	^ self cleanCanvas
]

{ #category : #accessing }
OPDiagramController >> commonElementControllers [
	^ self controllers select: #isCommon
]

{ #category : #accessing }
OPDiagramController >> commonElements [
	^ self commonElementControllers collect: #model as: Array
]

{ #category : #accessing }
OPDiagramController >> controllerFactory [
	^ OPControllerFactory withCommonElements
]

{ #category : #'controllers management' }
OPDiagramController >> controllerForModel: aModel [

	aModel = model ifTrue: [ ^ self ].
	^ self cachedControllerForModel: aModel
]

{ #category : #'controllers management' }
OPDiagramController >> controllerForModel: aModel ifFound: aFoundBlock [

	aModel = model ifTrue: [ ^ aFoundBlock value: self ].
	^ self cachedControllerForModel: aModel ifFound: aFoundBlock
]

{ #category : #'controllers management' }
OPDiagramController >> controllerForModel: aModel ifFound: aFoundBlock ifNone: aNoneBlock [

	aModel = model ifTrue: [ ^ aFoundBlock value: self ].
	^ self
		  cachedControllerForModel: aModel
		  ifFound: aFoundBlock
		  ifNone: aNoneBlock
]

{ #category : #'controllers management' }
OPDiagramController >> controllerForModel: aModel ifNone: aFoundBlock [

	aModel = model ifTrue: [ ^ self ].
	^ self cachedControllerForModel: aModel ifNone: aFoundBlock
]

{ #category : #'controllers management' }
OPDiagramController >> controllerForRoassalShape: aFigure [

	aFigure = self canvas ifTrue: [ ^ self ].
	^ self cachedControllerForRoassalShape: aFigure
	"^ self controllers detect: [ :ctrl | ctrl figure = aFigure ]"
]

{ #category : #'controllers management' }
OPDiagramController >> controllerForRoassalShape: aFigure ifNone: aBlock [

	aFigure = self canvas ifTrue: [ ^ self ].
	^ self cachedControllerForRoassalShape: aFigure ifNone: aBlock
	"^ self controllers detect: [ :ctrl | ctrl figure = aFigure ]"
]

{ #category : #deprecated }
OPDiagramController >> controllerNameFor: aModel [
	self deprecated: 'no replacement'
"	^ modelToControllerMapping at: aModel class"
]

{ #category : #'controllers management' }
OPDiagramController >> controllers [
	^ controllers ifNil: [ controllers := Set new ]
]

{ #category : #testing }
OPDiagramController >> controllersOfVisibleElements: aCollectionOfModelObject [
	^ aCollectionOfModelObject
		collect: [ :each | self controllerForModel: each ifNone: [ nil ] ]
		thenSelect: [ :each | each isNotNil ]
]

{ #category : #deprecated }
OPDiagramController >> createController: aModel [
	self
		deprecated: 'Use newControllerFor: instead'
		on: '8 November 2017'
		in: 'Pharo-6.0-60519-'.
	^ self newControllerFor: aModel
]

{ #category : #'protocol-canvas' }
OPDiagramController >> deselectAll [

	self announcer announce: OPAllFiguresDeselected new
]

{ #category : #accessing }
OPDiagramController >> diagram [

	self
		deprecated: 'Use diagramElement instead'
		transformWith: '`@receiver diagram ' -> '`@receiver diagramElement '.
	^ self diagramElement
]

{ #category : #accessing }
OPDiagramController >> diagram: aDiagram [

	self
		deprecated: 'Use diagram: instead'
		transformWith: '`@receiver diagram: `@statements1'
			-> '`@receiver diagramElement: `@statements1'.
	^ self diagramElement: aDiagram
]

{ #category : #accessing }
OPDiagramController >> diagramController [
	^ self
]

{ #category : #accessing }
OPDiagramController >> diagramController: aController [

	aController ifNil: [ ^ self ].
	aController = self ifTrue: [ ^ self ].
	self error: 'Cannot assign diagramController to diagramController'
]

{ #category : #userinterface }
OPDiagramController >> disableRefresh [
	self flag: #todo
]

{ #category : #'ui interaction' }
OPDiagramController >> editor [

	^ editor
]

{ #category : #'ui interaction' }
OPDiagramController >> editor: anEditor [
	editor := anEditor
]

{ #category : #userinterface }
OPDiagramController >> enableRefresh [
	self flag: #todo
]

{ #category : #accessing }
OPDiagramController >> figure [
	^ self canvas
]

{ #category : #accessing }
OPDiagramController >> figureAdded: aFigure [

	self
		deprecated: 'Use addedFigureFor: instead'
		transformWith: '`@receiver figureAdded: `@statements1'
			->
			'`@receiver addedFigureFor: (`@receiver controllerForFigure: `@statements1)'.
	^ self addedFigureFor: (self controllerForRoassalShape: aFigure)
]

{ #category : #accessing }
OPDiagramController >> figureContextClicked: anEvent [

	| shapes menu |
	shapes := (self selectedElements includes: anEvent shape)
		          ifTrue: [ self selectedElements ]
		          ifFalse: [ { anEvent shape } ].
	menu := CmdContextMenuActivation
		        buildContextMenuFor: self canvasPresenter
		        inContext:
		        (OPDiagramFigureContext for: self canvasPresenter of: shapes).
	menu popUpInWorld
]

{ #category : #deprecated }
OPDiagramController >> figureFor: aModel [
	self
		deprecated: 'Use figureForModel: instead'
		on: '8 November 2017'
		in: 'Pharo-6.0-60519-'.
	^ self figureForModel: aModel
]

{ #category : #accessing }
OPDiagramController >> figureForModel: aModel [
	^ (self controllerForModel: aModel) figure
]

{ #category : #'ui interaction' }
OPDiagramController >> form [

	^ self editor form
]

{ #category : #'controllers management' }
OPDiagramController >> hasControllerForFigure: aFigure [

	^ aFigure = self canvas or: [ 
		  self cachedControllerForRoassalShape: aFigure ifNone: [ ^ false ].
		  true ]
]

{ #category : #'controllers management' }
OPDiagramController >> hasControllerForModel: aModel [
	^ aModel = model
		or: [ self cachedControllerForModel: aModel ifNone: [ ^ false ].
			true ]
]

{ #category : #testing }
OPDiagramController >> hasRedo [
	^ self autosaveManager futureIsEmpty not
]

{ #category : #testing }
OPDiagramController >> hasSupportForModel: aModel [
	^ controllerFactory hasControllerFor: aModel
]

{ #category : #testing }
OPDiagramController >> hasUndo [
	^ self autosaveManager historyIsEmpty not
]

{ #category : #figures }
OPDiagramController >> hideAllElements [

	[ self controllers isNotEmpty ] whileTrue: [ 
		self controllers anyOne removeController ].
	self cleanCanvas.
	self canvas signalUpdate
]

{ #category : #figures }
OPDiagramController >> hideModelFromDiagram: aModel [
	self
		controllerForModel: aModel
		ifFound: [ :ctrl | ctrl removeController ]
]

{ #category : #'protocol-canvas' }
OPDiagramController >> hoverController: aController [

	self editor palette selectedTool hoveredController: aController
]

{ #category : #'protocol-canvas' }
OPDiagramController >> hoverRoassalShape: aFigure [

	self hoverController: (self controllerForRoassalShape: aFigure)
]

{ #category : #'ui interaction' }
OPDiagramController >> incompatiblePaletteItemNames [
	^ OPCommonElementController allSubclasses
		reject: [ :eachClass | self canBeTargetFor: eachClass new ]
		thenCollect: [ :each | each paletteItemName ]
]

{ #category : #initialization }
OPDiagramController >> initialize [
	super initialize.
	figureAdded := [ :figure |  ].
	controllerFactory := self controllerFactory.
	diagramController := self.
	figuresBeingAdded := Set new
]

{ #category : #'ui interaction' }
OPDiagramController >> initializePalette: aPalette [
	self subclassResponsibility
]

{ #category : #testing }
OPDiagramController >> isVisibleInDiagram: aModel [
	^ self hasControllerForModel: aModel
]

{ #category : #accessing }
OPDiagramController >> layout [
	controllers ifNil: [ ^ Dictionary new. ].
	"else"
	^ (controllers
		collect: [ :ctrl | ctrl model uuid -> ctrl layout ]
		thenReject: [ :each | each value isNone ]) asDictionary.
]

{ #category : #accessing }
OPDiagramController >> layout: aLayout [

	aLayout keysAndValuesDo: [ :key :value | 
		self controllers
			detect: [ :ctrl | ctrl model uuid = key ]
			ifFound: [ :ctrl | ctrl layout: value ] ].
	self updateCanvas
]

{ #category : #accessing }
OPDiagramController >> layouter [
	^ layouter
		ifNil: [ layouter := self plugin layouterClass new diagramController: self ]
]

{ #category : #accessing }
OPDiagramController >> layouter: aLayouter [
	layouter := aLayouter
]

{ #category : #'undo/redo' }
OPDiagramController >> loadState: aMemento [
"	| oldModel |
	aMemento ifNil: [ ^ self ].
	oldModel := self model.
	model := aMemento model.
	model announcer: oldModel announcer.
	self rebuild.
	self diagram: aMemento diagram.
	self logCr: aMemento diagram.
	self editor updateUndoRedo"
]

{ #category : #accessing }
OPDiagramController >> modelClass [
	^ self plugin modelClass
]

{ #category : #accessing }
OPDiagramController >> modelForFigure: aFigure [
	^ (self controllerForRoassalShape: aFigure) model
]

{ #category : #'events handling' }
OPDiagramController >> modelRemoved: aModel [
	self controllerForModel: aModel ifFound: #removeController
]

{ #category : #accessing }
OPDiagramController >> modelToControllerMapping [
	self
		deprecated: 'Use #controllerFactory instead'
		transformWith: '`@receiver modelToControllerMapping' -> '`@receiver controllerFactory'.
	^ self controllerFactory 
]

{ #category : #'as yet unclassified' }
OPDiagramController >> nameOfTypeForModel: aModel [
	self
		deprecated: 'use #name on typeOfModel: instead'
		transformWith:
			'`@receiver nameOfTypeForModel: `@argument'
				-> '(`@receiver typeOfModel: `@argument) name'.
	^ (self typeOfModel: aModel) name
]

{ #category : #'controllers management' }
OPDiagramController >> newControllerFor: aModel [
	^ controllerFactory newControllerFor: aModel
]

{ #category : #'ui interaction' }
OPDiagramController >> openInForm: aController [
	self form editController: aController
]

{ #category : #accessing }
OPDiagramController >> parent [
	^ self
]

{ #category : #accessing }
OPDiagramController >> plugin [
	^ plugin ifNil: [ OPPluginRegistry default pluginForController: self ]
]

{ #category : #rebuilding }
OPDiagramController >> rebuild [

	self deprecated: 'Might cause issues'.
	controllers := nil.
	[ :job | 
	job title: 'Preparing diagram'.
	diagramElement ifNil: [ 
		diagramElement := OPOpenPonkDiagram forModelElement: model ].
	diagramElement removeRender.
	diagramElement renderIn: self canvas.
	self showElements.
	diagramElement layout
		ifNil: [ self applyDefaultLayout ]
		ifNotNil: [ :layout | self layout: layout ] ] asJob run
]

{ #category : #'undo/redo' }
OPDiagramController >> redo [
	self assert: [ self hasRedo ].
	self loadState: self autosaveManager loadNext
]

{ #category : #deprecated }
OPDiagramController >> registerModelEvents: aModel [
	self deprecated: 'Use #model: and #internalSubscribeTo: instead'.
	"super registerModelEvents: aModel.
	aModel announcer when: OPElementChanged do: [ :evt | self saveState ]"
]

{ #category : #deprecated }
OPDiagramController >> remove [

	self error:
		'There should be no need to call #remove on DiagramController'
]

{ #category : #destruction }
OPDiagramController >> removeAllControllers [
	[ self controllers isNotEmpty ]
		whileTrue: [ self controllers anyOne removeController ]
]

{ #category : #'controllers management' }
OPDiagramController >> removeController: aController [
	self controllers remove: aController ifAbsent: [  ]
]

{ #category : #deprecated }
OPDiagramController >> removeControllerOf: aModelElement [
	self
		deprecated: 'Use #removeController: and #removeController instead'
		on: '8 November 2017'
		in: 'Pharo-6.0-60519-'.
	^ self removeController: (self controllerForModel: aModelElement)
]

{ #category : #destruction }
OPDiagramController >> removeFigure [

	self removeAllControllers.
	self figure ifNotNil: [ self figure shapes copy do: #remove ]
]

{ #category : #destruction }
OPDiagramController >> removeFromCanvas: aFigure [
	aFigure ifNil: [ ^ self ].
	(self controllerForRoassalShape: aFigure) removeFull
]

{ #category : #deprecated }
OPDiagramController >> removeFromModel: aModel [
	"Remove aModel from the diagram.
	It is aModel's owner's controller responsibility to remove it.
	The assertion tests whether aModel is attached to the current controller chain.
	"
	self deprecated: 'Use #removeModel on its controller instead.'

"	self assert: (self controllerForModel: aModel) model = aModel.
	(self controllerForModel: aModel owner) removeModelElement: aModel"
]

{ #category : #deprecated }
OPDiagramController >> removeModel [
	self deprecated: 'should not implement'.
	^ self shouldNotImplement
]

{ #category : #deprecated }
OPDiagramController >> removeModelElement: aModelElement [
	self deprecated: 'Use removeModel on its controller instead.'.
"	model remove: aModelElement"

	(self controllerForModel: aModelElement) removeModel
]

{ #category : #accessing }
OPDiagramController >> roassalShape [

	^ self canvas
]

{ #category : #'undo/redo' }
OPDiagramController >> saveState [
"	| memento |
	memento := self memento.
	self autosaveManager saveState: memento.
	self editor updateUndoRedo.
	self editor workbench projectController autoSave: memento"
]

{ #category : #'ui interaction' }
OPDiagramController >> selectController: aController [

	self editor palette selectSelectionTool selectedTool 
		selectedTargetControllers: { aController }
]

{ #category : #figures }
OPDiagramController >> selectableFigures [
	^ #()
]

{ #category : #accessing }
OPDiagramController >> selectedElements [

	^ (self canvas propertyAt: OPRSSelectableCanvas) selectedShapes
]

{ #category : #'protocol-canvas' }
OPDiagramController >> selectedShapes: shapes onPosition: aPoint [

	lastSelectionPosition := aPoint.
	self editor palette selectedTool selectedControllers:
		(shapes collect: [ :each | self controllerForRoassalShape: each ])
]

{ #category : #rebuilding }
OPDiagramController >> showAllElements [

	self disableRefresh.
	self showInDiagram: self.
	self enableRefresh.
	self controllers
		select: [ :each | each isKindOf: OPController ]
		thenDo: [ :each | each diagramElement updateRenderFromModel ]
]

{ #category : #rebuilding }
OPDiagramController >> showDiagramElement: aDiagramElement [

	| controller |
	controller := self
		              controllerForModel: aDiagramElement modelElement
		              ifFound: [ :ctrl | 
			              ctrl isRendered ifTrue: [ 
				              aDiagramElement isRendered ifTrue: [ ^ ctrl ].
				              ^ self error: 'Controller is already rendered' ].
			              ctrl ]
		              ifNone: [ 
		              self newControllerFor: aDiagramElement modelElement ].
	controller
		diagramElement: aDiagramElement;
		showWithoutDependentInDiagram: self.
	aDiagramElement ownedElements do: [ :each | 
		self showDiagramElement: each ].
	^ controller
]

{ #category : #rebuilding }
OPDiagramController >> showElements [

	diagramElement ownedElements do: [ :each | 
		self showDiagramElement: each ].
	diagramElement updateRenderFromSelf
]

{ #category : #figures }
OPDiagramController >> showInDiagramModel: aModel [
	self controllerForModel: aModel ifFound: [ :ctrl | ^ ctrl ].
	^ (self newControllerFor: aModel)
		showInDiagram: self;
		yourself
]

{ #category : #figures }
OPDiagramController >> showWithoutDependentInDiagramModel: aModel [
	self controllerForModel: aModel ifFound: [ :ctrl | ^ ctrl ].
	^ (self newControllerFor: aModel)
		showWithoutDependentInDiagram: self;
		yourself
]

{ #category : #'as yet unclassified' }
OPDiagramController >> typeOfModel: aModel [
	^ OPModelObjectType
		named:
			((aModel className withoutPrefix: self commonModelClassPrefix)
				splitOnCapitals joinUsing: ' ')
]

{ #category : #'undo/redo' }
OPDiagramController >> undo [
	self assert: [ self hasUndo ].
	self loadState: self autosaveManager loadPrevious
]

{ #category : #userinterface }
OPDiagramController >> updateCanvas [

	self controllers do: [ :each | 
		each diagramElement updateRenderFromModel ]
]

{ #category : #userinterface }
OPDiagramController >> updateView [

	self
		deprecated: 'Use #updateCanvas instead.'
		transformWith:
		'`@receiver updateView'
		-> '`@receiver updateCanvas'.
	^ self updateCanvas
]

{ #category : #accessing }
OPDiagramController >> view [

	self
		deprecated: 'Use #canvas instead.'
		transformWith: '`@receiver view' -> '`@receiver canvas'.
	^ self canvas
]

{ #category : #accessing }
OPDiagramController >> visibleElements [
	^ self allShowableElements
		select: [ :el | self isVisibleInDiagram: el ]
]

{ #category : #accessing }
OPDiagramController >> visibleElements: aCollection [
	| executor |
	aCollection ifEmpty: [ ^ self ].
	executor := OPShowHideFacade on: self.
	executor hideAll.
	executor
		showElements:
			(self allShowableElements
				select: [ :each | aCollection anySatisfy: [ :any | any = each ] ])
]

{ #category : #accessing }
OPDiagramController >> when: anEvent do: aBlock [

	^ self announcer when: anEvent do: aBlock
]

{ #category : #'protocol-events' }
OPDiagramController >> whenAllDeselectedDo: aBlock [

	self when: OPAllFiguresDeselected do: aBlock
]

{ #category : #'protocol-events' }
OPDiagramController >> whenFigureAdded: aBlock [
	figureAdded := aBlock ifNil: [ [ :figure |  ] ]
]

{ #category : #accessing }
OPDiagramController >> workbenchAnnouncer [
	^ workbenchAnnouncer
]

{ #category : #accessing }
OPDiagramController >> workbenchAnnouncer: anObject [
	workbenchAnnouncer := anObject
]

{ #category : #zoom }
OPDiagramController >> zoomToFit [

	self canvasPresenter zoomToFit
]
