"
I am an abstract base command for creating diagram elements (nodes, edges). I release ephemeral controller references after execution to prevent memory leaks in undo history.
"
Class {
	#name : 'OPCreateElementCommand',
	#superclass : 'OPDiagramCommand',
	#instVars : [
		'controller',
		'diagramController',
		'diagramElement',
		'geometryMemento',
		'parentModel',
		'viewModel',
		'viewModelRegistry',
		'owningDiagramElement'
	],
	#category : 'OpenPonk-Core-UndoRedo',
	#package : 'OpenPonk-Core',
	#tag : 'UndoRedo'
}

{ #category : 'executing' }
OPCreateElementCommand >> basicFirstExecution [
	"Execute initial creation and release both ephemeral controller references to prevent history memory leaks."
	diagramController ifNotNil: [
		controller diagramController: diagramController.
		self prepareControllerBeforeCreation.
		controller createModelIn: parentModel andShowInDiagram: diagramController.
		diagramElement := controller diagramElement.
		model := controller model.
		viewModel := controller viewModel.
		owningDiagramElement := (diagramElement owningElement isNotNil and: [ diagramElement owningElement isNoShape not ])
			ifTrue: [ diagramElement owningElement ]
			ifFalse: [ diagram ].
		self completeFirstExecution.
		controller := nil.
		diagramController := nil ]
]

{ #category : 'executing' }
OPCreateElementCommand >> basicRedo [
	self redoDomainModel.
	self redoDiagramElement
]

{ #category : 'executing' }
OPCreateElementCommand >> completeFirstExecution [
	"Hook for subclasses to complete spatial setup after first creation."
]

{ #category : 'accessing' }
OPCreateElementCommand >> controller [
	^ controller
]

{ #category : 'accessing' }
OPCreateElementCommand >> controller: aController [
	controller := aController
]

{ #category : 'accessing' }
OPCreateElementCommand >> diagramController [
	^ diagramController
]

{ #category : 'accessing' }
OPCreateElementCommand >> diagramController: aDiagramController [
	diagramController := aDiagramController.
	aDiagramController ifNotNil: [
		diagram := aDiagramController diagramElement.
		viewModelRegistry := aDiagramController viewModelRegistry.
		projectController := aDiagramController projectController ]
]

{ #category : 'accessing' }
OPCreateElementCommand >> diagramElement [
	^ diagramElement
]

{ #category : 'accessing' }
OPCreateElementCommand >> diagramElement: aDiagramElement [
	diagramElement := aDiagramElement
]

{ #category : 'executing' }
OPCreateElementCommand >> execute [
	model ifNil: [ self basicFirstExecution ] ifNotNil: [ self basicRedo ]
]

{ #category : 'testing' }
OPCreateElementCommand >> isDiagramOnly [
	"Answer whether this command targets a purely visual diagram-only element without a persistent domain model."
	(model isNotNil and: [ model isDiagramElement ]) ifTrue: [ ^ model isDiagramOnly ].
	diagramElement ifNotNil: [ :element | element isDiagramOnly ifTrue: [ ^ true ] ].
	controller ifNotNil: [ ^ controller isDiagramOnly ].
	^ false
]

{ #category : 'accessing' }
OPCreateElementCommand >> model: aModel [
	model := aModel
]

{ #category : 'accessing' }
OPCreateElementCommand >> parentModel [
	^ parentModel
]

{ #category : 'accessing' }
OPCreateElementCommand >> parentModel: aParentModel [
	parentModel := aParentModel
]

{ #category : 'executing' }
OPCreateElementCommand >> prepareControllerBeforeCreation [
	"Hook for subclasses to configure controller before model creation."
]

{ #category : 'executing' }
OPCreateElementCommand >> redoDiagramElement [
	diagram ifNotNil: [
		diagramElement ifNotNil: [
			geometryMemento ifNotNil: [ :savedMemento |
				diagramElement restoreGeometryFromMemento: savedMemento ]
			ifNil: [
				self restoreDiagramElementGeometry ].
			(owningDiagramElement isNotNil and: [ owningDiagramElement isNoShape not ])
				ifTrue: [ diagramElement owningElement: owningDiagramElement ]
				ifFalse: [ diagramElement owningElement: diagram ].
			self openDiagramController ifNotNil: [ :openController |
				openController showDiagramElement: diagramElement.
				openController updateCanvas ] ] ]
]

{ #category : 'executing' }
OPCreateElementCommand >> redoDomainModel [
	viewModel ifNotNil: [
		self viewModelRegistry ifNotNil: [ :registry |
			registry registerViewModel: viewModel for: model.
			viewModel subscribeToModel ] ].
	parentModel ifNotNil: [
		viewModel registerModelIn: parentModel ]
]

{ #category : 'executing' }
OPCreateElementCommand >> restoreDiagramElementGeometry [
	"Hook for subclasses to restore spatial bounds or edge waypoints/endpoints."
]

{ #category : 'executing' }
OPCreateElementCommand >> undo [
	diagramElement ifNotNil: [
		self undoDiagramElement ].
	self undoDomainModel
]

{ #category : 'executing' }
OPCreateElementCommand >> undoDiagramElement [
	geometryMemento := diagramElement captureGeometryMemento.
	diagramElement isRendered ifTrue: [ diagramElement removeRender ].
	"Do not nullify owningElement to preserve container/edge hierarchy for redo"
]

{ #category : 'executing' }
OPCreateElementCommand >> undoDomainModel [
	viewModel ifNotNil: [
		self viewModelRegistry ifNotNil: [ :registry |
			registry removeViewModelFor: model ] ].
	viewModel basicRemoveModel.
	viewModel unsubscribeFromModel.
	viewModel announceRemoval
]

{ #category : 'accessing' }
OPCreateElementCommand >> viewModel [
	^ viewModel
]

{ #category : 'accessing' }
OPCreateElementCommand >> viewModel: aViewModel [
	viewModel := aViewModel
]

{ #category : 'accessing' }
OPCreateElementCommand >> viewModelRegistry [
	^ viewModelRegistry ifNil: [
		projectController ifNotNil: [ :activeProjectController |
			activeProjectController viewModelRegistry ] ]
]

{ #category : 'accessing' }
OPCreateElementCommand >> viewModelRegistry: aRegistry [
	viewModelRegistry := aRegistry
]
