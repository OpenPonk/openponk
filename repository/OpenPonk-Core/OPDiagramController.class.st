"
A DCDiagramController is the parent class to controller classes that control whole diagrams. It (its decendant) creates a palette / menu  for specific diagram. It also handles the changes in diagram, e.g. removal of element. 
"
Class {
	#name : 'OPDiagramController',
	#superclass : 'OPController',
	#instVars : [
		'announcer',
		'controllers',
		'editor',
		'plugin',
		'autosaveManager',
		'modelToControllerCache',
		'workbenchAnnouncer',
		'layouter',
		'controllerFactory',
		'lastSelectionPosition',
		'canvasPresenter',
		'roassalShapeToControllerCache',
		'roassalShapeAdded',
		'roassalShapesBeingAdded'
	],
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'deprecated' }
OPDiagramController >> addAllElements [

	self
		deprecated: 'Use #showAllElements instead.'
		transformWith:
		'`@receiver addAllElements' -> '`@receiver showAllElements'.
	^ self showAllElements
]

{ #category : 'controllers management' }
OPDiagramController >> addController: aController [
	aController diagramController: self.
	self controllers add: aController
]

{ #category : 'accessing' }
OPDiagramController >> addMouseEventsFor: aRoassalShape [

	aRoassalShape
		when: RSMouseRightClick
		do: [ :event | self roassalShapeContextClicked: event ]
		for: self.
	aRoassalShape
		when: RSMouseEnter
		do: [ :event | self hoverRoassalShape: event shape ]
		for: self
]

{ #category : 'enumerating' }
OPDiagramController >> allModelElementsWithController [
	"Should return all elements that could be directly hidden on diagram but are currently shown"

	^ self controllers collect: [ :each | each model ]
]

{ #category : 'enumerating' }
OPDiagramController >> allModelElementsWithPossibleController [
	"all elements that could be directly hidden on diagram"

	^ (Set with: self model) , self elementsToShowInside
]

{ #category : 'enumerating' }
OPDiagramController >> allModelElementsWithPossibleDiagramElement [
	"all model elements that can have diagram elements (even if cannot have controller)"

	^ self allModelElementsWithPossibleController
]

{ #category : 'accessing' }
OPDiagramController >> announcer [

	^ announcer ifNil: [ announcer := Announcer new ]
]

{ #category : 'userinterface' }
OPDiagramController >> applyDefaultLayout [

	self layouter defaultLayout
]

{ #category : 'accessing' }
OPDiagramController >> autosaveManager [
	^ autosaveManager
		ifNil: [ autosaveManager := OPAutosaveManager
				on: self plugin singleStringSerializer ]
]

{ #category : 'controllers management' }
OPDiagramController >> cachedControllerForModel: aModel [

	^ modelToControllerCache at: aModel
]

{ #category : 'controllers management' }
OPDiagramController >> cachedControllerForModel: aModel ifFound: aFoundBlock [

	^ modelToControllerCache at: aModel ifPresent: aFoundBlock
]

{ #category : 'controllers management' }
OPDiagramController >> cachedControllerForModel: aModel ifFound: aFoundBlock ifNone: aNoneBlock [

	^ modelToControllerCache
		  at: aModel
		  ifPresent: aFoundBlock
		  ifAbsent: aNoneBlock
]

{ #category : 'controllers management' }
OPDiagramController >> cachedControllerForModel: aModel ifNone: aNoneBlock [

	^ modelToControllerCache at: aModel ifAbsent: aNoneBlock
]

{ #category : 'controllers management' }
OPDiagramController >> cachedControllerForRoassalShape: aRoassalShape [

	^ roassalShapeToControllerCache at: aRoassalShape
]

{ #category : 'controllers management' }
OPDiagramController >> cachedControllerForRoassalShape: aRoassalShape ifNone: aBlock [

	^ roassalShapeToControllerCache at: aRoassalShape ifAbsent: aBlock
]

{ #category : 'connecting' }
OPDiagramController >> canBeTargetFor: aController [
	^ (aController isKindOf: OPCommonElementController)
		and: [ aController class ~= OPCommonElementController ]
]

{ #category : 'accessing' }
OPDiagramController >> canvas [
	^ canvasPresenter canvas
]

{ #category : 'accessing' }
OPDiagramController >> canvasPresenter [

	^ canvasPresenter
]

{ #category : 'accessing' }
OPDiagramController >> canvasPresenter: aCanvasPresenter [

	canvasPresenter := aCanvasPresenter.
	self addMouseEventsFor: canvasPresenter canvas
]

{ #category : 'accessing' }
OPDiagramController >> commonElementControllers [
	^ self controllers select: #isCommon
]

{ #category : 'accessing' }
OPDiagramController >> commonElements [
	^ self commonElementControllers collect: #model as: Array
]

{ #category : 'accessing' }
OPDiagramController >> controllerFactory [
	^ OPControllerFactory withCommonElements
]

{ #category : 'controllers management' }
OPDiagramController >> controllerForModel: aModel [

	aModel = self model ifTrue: [ ^ self ].
	^ self cachedControllerForModel: aModel
]

{ #category : 'controllers management' }
OPDiagramController >> controllerForModel: aModel ifFound: aFoundBlock [

	aModel = self model ifTrue: [ ^ aFoundBlock value: self ].
	^ self cachedControllerForModel: aModel ifFound: aFoundBlock
]

{ #category : 'controllers management' }
OPDiagramController >> controllerForModel: aModel ifFound: aFoundBlock ifNone: aNoneBlock [

	aModel = self model ifTrue: [ ^ aFoundBlock value: self ].
	^ self
		  cachedControllerForModel: aModel
		  ifFound: aFoundBlock
		  ifNone: aNoneBlock
]

{ #category : 'controllers management' }
OPDiagramController >> controllerForModel: aModel ifNone: aFoundBlock [

	aModel = self model ifTrue: [ ^ self ].
	^ self cachedControllerForModel: aModel ifNone: aFoundBlock
]

{ #category : 'controllers management' }
OPDiagramController >> controllerForRoassalShape: aFigure [

	aFigure = self canvas ifTrue: [ ^ self ].
	^ self cachedControllerForRoassalShape: aFigure
	"^ self controllers detect: [ :ctrl | ctrl figure = aFigure ]"
]

{ #category : 'controllers management' }
OPDiagramController >> controllerForRoassalShape: aFigure ifNone: aBlock [

	aFigure = self canvas ifTrue: [ ^ self ].
	^ self cachedControllerForRoassalShape: aFigure ifNone: aBlock
	"^ self controllers detect: [ :ctrl | ctrl figure = aFigure ]"
]

{ #category : 'deprecated' }
OPDiagramController >> controllerNameFor: aModel [
	self deprecated: 'no replacement'
"	^ modelToControllerMapping at: aModel class"
]

{ #category : 'controllers management' }
OPDiagramController >> controllers [
	^ controllers ifNil: [ controllers := Set new ]
]

{ #category : 'testing' }
OPDiagramController >> controllersOfVisibleElements: aCollectionOfModelObject [
	^ aCollectionOfModelObject
		collect: [ :each | self controllerForModel: each ifNone: [ nil ] ]
		thenSelect: [ :each | each isNotNil ]
]

{ #category : 'deprecated' }
OPDiagramController >> createController: aModel [
	self
		deprecated: 'Use newControllerFor: instead'
		on: '8 November 2017'
		in: 'Pharo-6.0-60519-'.
	^ self newControllerFor: aModel
]

{ #category : 'protocol-canvas' }
OPDiagramController >> deselectAll [

	self announcer announce: OPAllShapesDeselected new
]

{ #category : 'accessing' }
OPDiagramController >> diagram [

	^ self diagramElement
]

{ #category : 'accessing' }
OPDiagramController >> diagram: aDiagram [

	self
		deprecated: 'Use diagram: instead'
		transformWith: '`@receiver diagram: `@statements1'
			-> '`@receiver diagramElement: `@statements1'.
	^ self diagramElement: aDiagram
]

{ #category : 'accessing' }
OPDiagramController >> diagramController [
	^ self
]

{ #category : 'accessing' }
OPDiagramController >> diagramController: aController [

	aController ifNil: [ ^ self ].
	aController = self ifTrue: [ ^ self ].
	self error: 'Cannot assign diagramController to diagramController'
]

{ #category : 'rebuilding' }
OPDiagramController >> diagramFocused [

	self updateAfterDiagramFocused.
	self isRendered ifTrue: [ ^ self ].

	self diagramElement canvas: self canvas.
	self diagramElement ownedElements do: [ :each |
		self showDiagramElement: each ].
	self diagramElement updateRenderFromSelf
]

{ #category : 'userinterface' }
OPDiagramController >> disableRefresh [
	self flag: #todo
]

{ #category : 'ui interaction' }
OPDiagramController >> editor [

	^ editor
]

{ #category : 'ui interaction' }
OPDiagramController >> editor: anEditor [
	editor := anEditor
]

{ #category : 'destruction' }
OPDiagramController >> elementRemoved [

	self editor ifNotNil: [ :foundEditor |
		foundEditor workbench ifNotNil: [ :workbench |
			workbench projectTree ifNotNil: [ :projectTree |
				projectTree refresh ] ] ]
]

{ #category : 'userinterface' }
OPDiagramController >> enableRefresh [
	self flag: #todo
]

{ #category : 'figures' }
OPDiagramController >> ensureControllerFor: aModel [

	| controller |
	self controllerForModel: aModel ifFound: [ :ctrl | ^ ctrl ].
	controller := self newControllerFor: aModel.
	self addController: controller.
	^ controller
]

{ #category : 'ui interaction' }
OPDiagramController >> ensureDeselected [

	self deselectAll
]

{ #category : 'accessing' }
OPDiagramController >> figureAdded: aFigure [

	self
		deprecated: 'Use rendered: instead'
		transformWith: '`@receiver figureAdded: `@statements1'
			->
			'`@receiver rendered: (`@receiver controllerForRoassalShape: `@statements1)'.
	^ self rendered: (self controllerForRoassalShape: aFigure)
]

{ #category : 'ui interaction' }
OPDiagramController >> form [

	^ self editor form
]

{ #category : 'controllers management' }
OPDiagramController >> hasControllerForModel: aModel [

	^ aModel = self model or: [
		  self cachedControllerForModel: aModel ifNone: [ ^ false ].
		  true ]
]

{ #category : 'controllers management' }
OPDiagramController >> hasControllerForRoassalShape: aRoassalShape [

	^ aRoassalShape = self canvas or: [ 
		  self cachedControllerForRoassalShape: aRoassalShape ifNone: [ ^ false ].
		  true ]
]

{ #category : 'testing' }
OPDiagramController >> hasRedo [
	^ self autosaveManager futureIsEmpty not
]

{ #category : 'testing' }
OPDiagramController >> hasSupportForModel: aModel [
	^ controllerFactory hasControllerFor: aModel
]

{ #category : 'testing' }
OPDiagramController >> hasUndo [
	^ self autosaveManager historyIsEmpty not
]

{ #category : 'figures' }
OPDiagramController >> hideAllElements [

	[ self controllers isNotEmpty ] whileTrue: [ 
		self controllers anyOne removeControllerAndDiagramElement ].
	self canvas signalUpdate
]

{ #category : 'figures' }
OPDiagramController >> hideModelFromDiagram: aModel [
	self
		controllerForModel: aModel
		ifFound: [ :ctrl | ctrl removeControllerAndDiagramElement ]
]

{ #category : 'protocol-canvas' }
OPDiagramController >> hoverController: aController [

	self editor palette selectedTool hoveredController: aController
]

{ #category : 'protocol-canvas' }
OPDiagramController >> hoverRoassalShape: aRoassalShape [

	self hoverController: (self controllerForRoassalShape: aRoassalShape)
]

{ #category : 'ui interaction' }
OPDiagramController >> incompatiblePaletteItemNames [
	^ OPCommonElementController allSubclasses
		reject: [ :eachClass | self canBeTargetFor: eachClass new ]
		thenCollect: [ :each | each paletteItemName ]
]

{ #category : 'initialization' }
OPDiagramController >> initialize [

	super initialize.
	roassalShapeAdded := [ :roassalShape |  ].
	controllerFactory := self controllerFactory.
	diagramController := self.
	roassalShapesBeingAdded := Set new.
	modelToControllerCache := OPModelToControllerCache for: self.
	roassalShapeToControllerCache := OPRoassalShapeToControllerCache for: self
]

{ #category : 'ui interaction' }
OPDiagramController >> initializePalette: aPalette [
	self subclassResponsibility
]

{ #category : 'testing' }
OPDiagramController >> isVisibleInDiagram: aModel [
	^ self hasControllerForModel: aModel
]

{ #category : 'accessing' }
OPDiagramController >> layouter [
	^ layouter
		ifNil: [ layouter := self plugin layouterClass new diagramController: self ]
]

{ #category : 'accessing' }
OPDiagramController >> layouter: aLayouter [
	layouter := aLayouter
]

{ #category : 'undo/redo' }
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

{ #category : 'accessing' }
OPDiagramController >> modelClass [
	^ self plugin modelClass
]

{ #category : 'accessing' }
OPDiagramController >> modelForFigure: aFigure [
	self
		deprecated: 'use #modelForRoassalShape: instead'
		transformWith:
			'`@receiver modelForFigure: `@argument'
				-> '`@receiver modelForRoassalShape: `@argument'.

	^ self modelForRoassalShape: aFigure
]

{ #category : 'accessing' }
OPDiagramController >> modelForRoassalShape: aRoassalShape [
	^ (self controllerForRoassalShape: aRoassalShape) model
]

{ #category : 'accessing' }
OPDiagramController >> modelToControllerMapping [
	self
		deprecated: 'Use #controllerFactory instead'
		transformWith: '`@receiver modelToControllerMapping' -> '`@receiver controllerFactory'.
	^ self controllerFactory 
]

{ #category : 'controllers management' }
OPDiagramController >> modelsWithController [

	^ self controllers collect: #model
]

{ #category : 'accessing' }
OPDiagramController >> nameOfTypeForModel: aModel [
	self
		deprecated: 'use #name on typeOfModel: instead'
		transformWith:
			'`@receiver nameOfTypeForModel: `@argument'
				-> '(`@receiver typeOfModel: `@argument) name'.
	^ (self typeOfModel: aModel) name
]

{ #category : 'controllers management' }
OPDiagramController >> newControllerFor: aModel [

	^ controllerFactory newControllerFor: aModel
]

{ #category : 'ui interaction' }
OPDiagramController >> openInForm: aController [
	self form editController: aController
]

{ #category : 'connecting' }
OPDiagramController >> parentContainerModel [
	"I do not have any further parent"

	^ self model
]

{ #category : 'accessing' }
OPDiagramController >> plugin [
	^ plugin ifNil: [ OPPluginRegistry default pluginForController: self ]
]

{ #category : 'undo/redo' }
OPDiagramController >> redo [
	self assert: [ self hasRedo ].
	self loadState: self autosaveManager loadNext
]

{ #category : 'deprecated' }
OPDiagramController >> registerModelEvents: aModel [
	self deprecated: 'Use #model: and #internalSubscribeTo: instead'.
	"super registerModelEvents: aModel.
	aModel announcer when: OPElementChanged do: [ :evt | self saveState ]"
]

{ #category : 'deprecated' }
OPDiagramController >> remove [

	self error:
		'There should be no need to call #remove on DiagramController'
]

{ #category : 'destruction' }
OPDiagramController >> removeAllControllers [

	[ self controllers isNotEmpty ] whileTrue: [
		self controllers anyOne removeController ]
]

{ #category : 'controllers management' }
OPDiagramController >> removeController: aController [

	self controllers remove: aController ifAbsent: [  ]
]

{ #category : 'deprecated' }
OPDiagramController >> removeControllerOf: aModelElement [
	self
		deprecated: 'Use #removeController: and #removeController instead'
		on: '8 November 2017'
		in: 'Pharo-6.0-60519-'.
	^ self removeController: (self controllerForModel: aModelElement)
]

{ #category : 'destruction' }
OPDiagramController >> removeFromCanvas: aRoassalShape [

	self
		deprecated: 'use removeModelOfRoassalShape: instead'
		transformWith: '`@rcv removeFromCanvas: `@arg'
			-> '`@rcv removeModelOfRoassalShape: `@arg'
]

{ #category : 'deprecated' }
OPDiagramController >> removeFromModel: aModel [
	"Remove aModel from the diagram.
	It is aModel's owner's controller responsibility to remove it.
	The assertion tests whether aModel is attached to the current controller chain.
	"
	self deprecated: 'Use #removeModel on its controller instead.'

"	self assert: (self controllerForModel: aModel) model = aModel.
	(self controllerForModel: aModel owner) removeModelElement: aModel"
]

{ #category : 'deprecated' }
OPDiagramController >> removeModel [
	self deprecated: 'should not implement'.
	^ self shouldNotImplement
]

{ #category : 'deprecated' }
OPDiagramController >> removeModelElement: aModelElement [
	self deprecated: 'Use removeModel on its controller instead.'.
"	model remove: aModelElement"

	(self controllerForModel: aModelElement) removeModel
]

{ #category : 'destruction' }
OPDiagramController >> removeModelOfRoassalShape: aRoassalShape [

	aRoassalShape ifNil: [ ^ self ].
	(self controllerForRoassalShape: aRoassalShape)
		removeControllerAndModel
]

{ #category : 'accessing' }
OPDiagramController >> rendered: aController [

	(roassalShapesBeingAdded includes: aController)
		ifFalse: [
			self traceCr:
				'DiagramController>>#addedFigureFor: added figure not previously marked as being added' ]
		ifTrue: [ roassalShapesBeingAdded remove: aController ].


	lastSelectionPosition ifNotNil: [
		aController diagramElement addedByMouseClickTo:
			lastSelectionPosition.
		lastSelectionPosition := nil ].
	self addMouseEventsFor: aController roassalShape
]

{ #category : 'accessing' }
OPDiagramController >> roassalShape [

	^ self canvas
]

{ #category : 'accessing' }
OPDiagramController >> roassalShapeContextClicked: anEvent [

	| shapes menu |
	shapes := (self selectedElements includes: anEvent shape)
		          ifTrue: [ self selectedElements ]
		          ifFalse: [ { anEvent shape } ].
	menu := CmdContextMenuActivation
		        buildContextMenuFor: self canvasPresenter
		        inContext:
		        (OPRoassalShapeContext for: self canvasPresenter of: shapes).
	menu popUpInWorld
]

{ #category : 'accessing' }
OPDiagramController >> roassalShapeForModel: aModel [

	^ (self controllerForModel: aModel) roassalShape
]

{ #category : 'undo/redo' }
OPDiagramController >> saveState [
"	| memento |
	memento := self memento.
	self autosaveManager saveState: memento.
	self editor updateUndoRedo.
	self editor workbench projectController autoSave: memento"
]

{ #category : 'ui interaction' }
OPDiagramController >> selectController: aController [

	self editor palette selectSelectionTool selectedTool 
		selectedTargetControllers: { aController }
]

{ #category : 'accessing' }
OPDiagramController >> selectedElements [

	^ (self canvas propertyAt: OPRSSelectableCanvas) selectedShapes
]

{ #category : 'protocol-canvas' }
OPDiagramController >> selectedShapes: shapes onPosition: aPoint [

	lastSelectionPosition := aPoint.
	self editor palette selectedTool selectedControllers:
		(shapes collect: [ :each | self controllerForRoassalShape: each ])
]

{ #category : 'rebuilding' }
OPDiagramController >> showAllElements [

	self disableRefresh.
	self allModelElementsWithPossibleController do: [ :each | 
		self showWithoutDependentInDiagramModel: each ].
	self enableRefresh
]

{ #category : 'rebuilding' }
OPDiagramController >> showDiagramElement: aDiagramElement [

	aDiagramElement shouldHaveController ifTrue: [
		| controller |
		controller := self
			              controllerForModel: aDiagramElement ownModelElement
			              ifFound: [ :ctrl |
				              ctrl isRendered ifTrue: [
					              aDiagramElement isRendered ifTrue: [ ^ ctrl ].
					              ^ self error:
						                'Controller is already rendered by a different diagram element' ].
				              ctrl ]
			              ifNone: [
			              self newControllerFor:
				              aDiagramElement ownModelElement ].
		controller
			diagramElement: aDiagramElement;
			showWithoutDependentInDiagram: self ].
	aDiagramElement ownedElements do: [ :each |
		self showDiagramElement: each ]
]

{ #category : 'figures' }
OPDiagramController >> showInDiagramModel: aModel [

	self controllerForModel: aModel ifFound: [ :ctrl | ^ ctrl ].
	^ (self newControllerFor: aModel)
		  showInDiagram: self;
		  yourself
]

{ #category : 'construction' }
OPDiagramController >> showWithoutDependentInDiagram: aDiagramController [

	self = aDiagramController ifFalse: [ self error: 'Cannot show a diagram inside another diagram' ]
	
	"do nothing"
]

{ #category : 'figures' }
OPDiagramController >> showWithoutDependentInDiagramModel: aModel [

	self controllerForModel: aModel ifFound: [ :ctrl | ^ ctrl ].
	^ (self newControllerFor: aModel)
		  showWithoutDependentInDiagram: self;
		  yourself
]

{ #category : 'accessing' }
OPDiagramController >> typeOfModel: aModel [
	^ OPModelObjectType
		named:
			((aModel className withoutPrefix: self commonModelClassPrefix)
				splitCamelCase joinUsing: ' ')
]

{ #category : 'undo/redo' }
OPDiagramController >> undo [
	self assert: [ self hasUndo ].
	self loadState: self autosaveManager loadPrevious
]

{ #category : 'event handling' }
OPDiagramController >> updateAfterDiagramFocused [

	| modelElementsToKeep |
	modelElementsToKeep := self
		                       allModelElementsWithPossibleDiagramElement
		                       asIdentitySet.
	self controllers
		reject: [ :each | each isDiagramOnly ]
		thenDo: [ :each |
			(modelElementsToKeep includes: each model)
				ifTrue: [ each updateAfterDiagramFocused ]
				ifFalse: [ each removeControllerAndDiagramElement ] ].
	self diagramElement allOwnedElements asIdentitySet
		reject: [ :each |
			each isDiagramOnly or: [
				modelElementsToKeep includes: each modelElement ] ]
		thenDo: [ :each | each remove ]
]

{ #category : 'userinterface' }
OPDiagramController >> updateCanvas [

	self canvas signalUpdate
]

{ #category : 'userinterface' }
OPDiagramController >> updateView [

	self
		deprecated: 'Use #updateCanvas instead.'
		transformWith:
		'`@receiver updateView'
		-> '`@receiver updateCanvas'.
	^ self updateCanvas
]

{ #category : 'validation' }
OPDiagramController >> validate [

	self controllers do: [ :each | each validate ]
]

{ #category : 'accessing' }
OPDiagramController >> view [

	self
		deprecated: 'Use #canvas instead.'
		transformWith: '`@receiver view' -> '`@receiver canvas'.
	^ self canvas
]

{ #category : 'accessing' }
OPDiagramController >> visibleElements [
	^ self allModelElementsWithPossibleController
		select: [ :el | self isVisibleInDiagram: el ]
]

{ #category : 'accessing' }
OPDiagramController >> visibleElements: aCollection [
	| executor |
	aCollection ifEmpty: [ ^ self ].
	executor := OPShowHideFacade on: self.
	executor hideAll.
	executor
		showElements:
			(self allModelElementsWithPossibleController
				select: [ :each | aCollection anySatisfy: [ :any | any = each ] ])
]

{ #category : 'accessing' }
OPDiagramController >> when: anEvent do: aBlock for: aSubscriber [

	^ self announcer when: anEvent do: aBlock for: aSubscriber
]

{ #category : 'protocol-events' }
OPDiagramController >> whenAllDeselectedDo: aBlock for: aSubscriber [

	self when: OPAllShapesDeselected do: aBlock for: aSubscriber
]

{ #category : 'protocol-events' }
OPDiagramController >> whenFigureAdded: aBlock [
	roassalShapeAdded := aBlock ifNil: [ [ :figure |  ] ]
]

{ #category : 'accessing' }
OPDiagramController >> willRender: aController [

	(roassalShapesBeingAdded includes: aController) ifTrue: [ 
		self notify: 'Same controller is already being added' ].
	roassalShapesBeingAdded add: aController
]

{ #category : 'accessing' }
OPDiagramController >> workbenchAnnouncer [
	^ workbenchAnnouncer
]

{ #category : 'accessing' }
OPDiagramController >> workbenchAnnouncer: anObject [
	workbenchAnnouncer := anObject
]

{ #category : 'zoom' }
OPDiagramController >> zoomToFit [

	self canvasPresenter zoomToFit
]
