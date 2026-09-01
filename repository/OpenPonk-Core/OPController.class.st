"
Base class for all OpenPonk controllers.
Coordinates the interaction between DiagramElements and ViewModels. Following the introduction of ViewModels, I no longer handle model element lifecycles, delegating domain logic to ViewModels and focusing on diagram view coordination.
"
Class {
	#name : 'OPController',
	#superclass : 'Object',
	#instVars : [
		'diagramController',
		'diagramElement',
		'viewModel',
		'viewModelRegistry'
	],
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'accessing' }
OPController class >> modelClass [
	^ self viewModelClass modelClass
]

{ #category : 'accessing' }
OPController class >> viewModelClass [
	^ self subclassResponsibility
]

{ #category : 'connecting' }
OPController >> addAsSourceFor: aController [

	(self canBeSourceFor: aController) ifFalse: [
			self error: self class asString , ' cannot be source for '
				, aController class asString ].
	aController viewModelRegistry: self viewModelRegistry.
	aController source: self
]

{ #category : 'connecting' }
OPController >> addAsTargetFor: aController [

	(self canBeTargetFor: aController) ifFalse: [
			self error: self class asString , ' cannot be target for '
				, aController class asString ].
	aController viewModelRegistry: self viewModelRegistry.
	aController target: self.
	aController
		createModelIn: (self parentWhenTargetFor: aController)
		andShowInDiagram: self diagramController
]

{ #category : 'forms' }
OPController >> buildEditorForm: aForm [
	^ self viewModel buildEditorForm: aForm
]

{ #category : 'connecting' }
OPController >> canBeSourceFor: aController [
	^ false
]

{ #category : 'connecting' }
OPController >> canBeTargetFor: aController [
	^ false
]

{ #category : 'accessing' }
OPController >> commonModelClassPrefix [

	self
		deprecated: 'Use class viewModelClass commonModelClassPrefix instead'
		transformWith:
		'`@receiver commonModelClassPrefix' -> '`@receiver class viewModelClass commonModelClassPrefix'.

	^ self class viewModelClass commonModelClassPrefix
]

{ #category : 'ui-hooks' }
OPController >> creationUICommandClass [

	^ self viewModel creationUICommandClass
]

{ #category : 'accessing' }
OPController >> dependentControllers [

	^ self viewModel ifNil: [ #(  ) ] ifNotNil: [ :vm |
			  vm dependentElements asSet
				  collect: [ :each |
					  self diagramController controllerForModel: each ifNone: [ nil ] ]
				  thenSelect: #isNotNil ]
]

{ #category : 'deprecation' }
OPController >> dependentElements [
	self deprecated: 'Use viewModel instead' transformWith: '`@receiver dependentElements' -> '`@receiver viewModel dependentElements'.
	^ self viewModel ifNotNil: [ :vm | vm dependentElements ] ifNil: [ #() ]
]

{ #category : 'forms' }
OPController >> descriptionName [
	self deprecated: 'Use viewModel instead' transformWith: '`@receiver descriptionName' -> '`@receiver viewModel descriptionName'.
	^ self viewModel descriptionName
]

{ #category : 'accessing' }
OPController >> diagram [

	^ self diagramController diagram
]

{ #category : 'accessing' }
OPController >> diagramController [
	^ diagramController
]

{ #category : 'accessing' }
OPController >> diagramController: aDiagramController [

	diagramController := aDiagramController.
	self viewModelRegistry: diagramController viewModelRegistry
]

{ #category : 'accessing' }
OPController >> diagramElement [

	^ diagramElement ifNil: [ OPNoShape instance ]
]

{ #category : 'accessing' }
OPController >> diagramElement: aDiagramElement [

	^ diagramElement := aDiagramElement
]

{ #category : 'accessing' }
OPController >> elementsToShowInside [
	"Returns model elements that should be shown (made visible in diagram) when own model is shown"

	^ self viewModel essentialChildrenModels
]

{ #category : 'ui interaction' }
OPController >> ensureDeselected [

	self subclassResponsibility
]

{ #category : 'accessing' }
OPController >> ensureDiagramElement [

	self assert: self diagramElement exists.
	self linkDiagramElementToModel.
	^ self diagramElement
]

{ #category : 'forms' }
OPController >> formEventsAnnouncer [

	^ self viewModel announcer
]

{ #category : 'canvas actions' }
OPController >> hideSelectionFeedback [

	self deprecated: 'This should be done by shapes (diagram elements)'
]

{ #category : 'testing' }
OPController >> isHideable [

	^ false
]

{ #category : 'testing' }
OPController >> isRendered [

	^ self diagramElement isRendered
]

{ #category : 'testing' }
OPController >> isTargetUsedAsContainer [

	^ true
]

{ #category : 'construction' }
OPController >> linkDiagramElementToModel [

	self diagramElement modelElement: self model
]

{ #category : 'accessing' }
OPController >> model [
    ^ self viewModel ifNotNil: [ :vm | vm model ]
]

{ #category : 'accessing' }
OPController >> model: aModel [

	self viewModel: (aModel ifNotNil: [
				 aModel uuid ifNil: [
					 self error:
						 'All model objects must have a uuid to be used by OP' ].
				 self viewModelRegistry viewModelFor: aModel ])
]

{ #category : 'announcements' }
OPController >> modelChanged [

	self diagramElement modelChanged
]

{ #category : 'accessing' }
OPController >> modelClass [
	^ self class modelClass
]

{ #category : 'destruction' }
OPController >> modelRemoved [
	"The domain model was destroyed. Remove own visual representation and deregister."

	self removeFromDiagramController.
	self removeDiagramElement.

	self viewModel: nil
]

{ #category : 'accessing' }
OPController >> nameOfType [

	self
		deprecated: 'Use viewModel nameOfType instead'
		transformWith:
		'`@receiver nameOfType' -> '`@receiver viewModel nameOfType'.

	^ self viewModel nameOfType
]

{ #category : 'connecting' }
OPController >> parentContainerModel [

	self
		deprecated: 'Use viewModel parentContainerModel instead'
		transformWith: '`@receiver parentContainerModel'
			-> '`@receiver viewModel parentContainerModel'.

	^ self viewModel parentContainerModel
]

{ #category : 'connecting' }
OPController >> parentWhenTargetFor: aCreatedController [

	^ aCreatedController isTargetUsedAsContainer
		  ifTrue: [ self model ]
		  ifFalse: [ self viewModel parentContainerModel ]
]

{ #category : 'figures' }
OPController >> refreshFigure [

	self
		deprecated: 'Use #modelChanged instead'
		transformWith: '`@receiver refreshFigure'
			-> '`@receiver modelChanged'.

	^ self modelChanged
]

{ #category : 'deprecated' }
OPController >> remove [

	self deprecated: 'Use removeControllerAndDiagramElement instead.'.
	self removeControllerAndDiagramElement
]

{ #category : 'destruction' }
OPController >> removeController [
    self viewModel ifNotNil: [
        self removeDependentControllers.
        self unsubscribeFromViewModel ].
    self removeRender.
    self removeFromDiagramController
]

{ #category : 'destruction' }
OPController >> removeControllerAndDiagramElement [
    self viewModel ifNotNil: [
        self removeDependentControllersAndDiagramElements.
        self unsubscribeFromViewModel ].
    self removeFromDiagramController.
    self removeDiagramElement
]

{ #category : 'destruction' }
OPController >> removeControllerAndModel [

	self viewModel removeModel
]

{ #category : 'destruction' }
OPController >> removeDependentConrollersAndModels [

	self dependentControllers do: [ :each |
		self diagramController
			controllerForModel: each model
			ifFound: [ :found | found removeControllerAndModel ] ]
]

{ #category : 'destruction' }
OPController >> removeDependentControllers [

	self dependentControllers do: [ :each |
		self diagramController controllers
			detect: [ :ctrl | ctrl model = each model ]
			ifFound: #removeController ]
]

{ #category : 'destruction' }
OPController >> removeDependentControllersAndDiagramElements [
	self dependentControllers
		do: [ :each | 
			self diagramController controllers
				detect: [ :ctrl | ctrl model = each model ]
				ifFound: #removeControllerAndDiagramElement ]
]

{ #category : 'destruction' }
OPController >> removeDiagramElement [

	self diagramElement remove.
	self diagramElement: nil
]

{ #category : 'destruction' }
OPController >> removeFromDiagramController [

	self diagramController ifNil: [ ^ self ].
	self ensureDeselected.
	self diagramController removeController: self
]

{ #category : 'removing' }
OPController >> removeModel [
	self
		deprecated: 'Use #removeModel on ViewModel instead'
		transformWith: '`@receiver removeModel' -> '`@receiver viewModel removeModel'.
	^ self viewModel removeModel
]

{ #category : 'destruction' }
OPController >> removeRender [

	self ensureDeselected.
	self diagramElement removeRender
]

{ #category : 'figures' }
OPController >> roassalShape [

	^ self diagramElement roassalShape
]

{ #category : 'canvas actions' }
OPController >> showAcceptFeedbackFor: aController [
	"Return something that understands #remove, or nil to not show any feedback."

	^ OPRSAcceptDenyFeedbackBuilder acceptFeedbackFor: self roassalShape
]

{ #category : 'canvas actions' }
OPController >> showDenyFeedbackFor: aController [
	"Return something that understands #remove, or nil to not show any feedback."

	^ OPRSAcceptDenyFeedbackBuilder denyFeedbackFor: self roassalShape
]

{ #category : 'construction' }
OPController >> showInDiagram: aDiagramController [
	self showWithoutDependentInDiagram: aDiagramController.
	self viewModel ifNotNil: [ :vm |
		vm dependentElements do: [ :each |
			aDiagramController showInDiagramModel: each ] ]
]

{ #category : 'canvas actions' }
OPController >> showSelectionFeedback [

	self deprecated: 'This should be done by shapes (diagram elements)'
]

{ #category : 'construction' }
OPController >> showWithoutDependentInDiagram: aDiagramController [

	self subclassResponsibility
]

{ #category : 'announcements' }
OPController >> subscribeToViewModel [

	self viewModel announcer weak
		when: OPElementRenamed send: #modelChanged to: self;
		when: OPModelChanged send: #modelChanged to: self;
		when: OPModelRemoved do: [ :ann |
				ann model ifNotNil: [ :removedModel |
						removedModel == self model ifTrue: [ self modelRemoved ] ] ]
		for: self
]

{ #category : 'announcements' }
OPController >> unsubscribeFromViewModel [
    self viewModel unsubscribe: self
]

{ #category : 'event handling' }
OPController >> updateAfterDiagramFocused [

	self subclassResponsibility
]

{ #category : 'validation' }
OPController >> validate [
	^ self viewModel validate
]

{ #category : 'accessing' }
OPController >> viewModel [
    ^ viewModel
]

{ #category : 'accessing' }
OPController >> viewModel: aViewModel [
    viewModel ifNotNil: [ self unsubscribeFromViewModel ].
    viewModel := aViewModel.
    viewModel ifNotNil: [ self subscribeToViewModel ]
]

{ #category : 'accessing' }
OPController >> viewModelRegistry [

	^ viewModelRegistry
]

{ #category : 'accessing' }
OPController >> viewModelRegistry: aViewModelRegistry [

	viewModelRegistry := aViewModelRegistry
]
