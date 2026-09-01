"
Abstract base class for controllers managing specific diagram elements (such as nodes and edges). 
Coordinates the visual representation (Roassal shapes) and interacts with the element's ViewModel. 
Does not directly manage the domain model lifecycle, delegating that responsibility to the ViewModel.
"
Class {
	#name : 'OPElementController',
	#superclass : 'OPController',
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPElementController class >> diagramElementClass [

	^ self subclassResponsibility
]

{ #category : 'construction' }
OPElementController >> createDiagramElement [

	^ self diagramElement: (self diagramElementClass
			   in: self intendedOwningDiagramElement
			   forModelElement: self model)
]

{ #category : 'construction' }
OPElementController >> createModelIn: aParentModel [

	self viewModel: (self viewModelRegistry
			 registerNewViewModelOfClass: self class viewModelClass
			 createdBy: [ :newViewModel |
			 newViewModel createModelIn: aParentModel ]).
	^ self model
]

{ #category : 'construction' }
OPElementController >> createModelIn: aParentModel andShowInDiagram: aDiagramController [
	self diagramController: aDiagramController.
	self removeDiagramElement.
	self createModelIn: aParentModel.
	self showWithoutDependentInDiagram: aDiagramController
]

{ #category : 'deprecation' }
OPElementController >> dependingOnElements [
	self deprecated: 'Use viewModel instead' transformWith: '`@receiver dependingOnElements' -> '`@receiver viewModel dependingOnElements'.
	^ self viewModel ifNotNil: [ :vm | vm dependingOnElements ] ifNil: [ Set empty ]
]

{ #category : 'accessing' }
OPElementController >> diagramElementClass [
    ^ self class diagramElementClass
]

{ #category : 'diagram elements' }
OPElementController >> diagramElementOwnerWithPossibleController [

	^ self diagramElement owningElementWithPossibleController
]

{ #category : 'ui interaction' }
OPElementController >> ensureDeselected [
	self isRendered ifFalse: [ ^ self ].
	self roassalShape propertyAt: OPRSSelectable ifPresent: [ :selectable |
		selectable deselect: self roassalShape ]
]

{ #category : 'accessing' }
OPElementController >> ensureDiagramElement [

	self diagramElement
		ifExists: [ self linkDiagramElementToModel ]
		else: [
			self diagram
				diagramElementOfType: self diagramElementClass
				withModelElement: self model
				ifFound: [ :found | ^ self diagramElement: found ].
			self createDiagramElement ].
	^ self diagramElement
]

{ #category : 'construction' }
OPElementController >> ensureShownDependenciesInDiagram: aDiagramController [
	self viewModel ifNotNil: [ :vm |
		vm dependingOnElements do: [ :each |
			aDiagramController showWithoutDependentInDiagramModel: each ] ]
]

{ #category : 'figures' }
OPElementController >> figure: aFigure [

	self deprecated:
		'Figure (Roassal shape) cannot be set directly anymore.'
]

{ #category : 'deprecated' }
OPElementController >> figureLabel: aLabelName text: aString [
	self deprecated: 'Method will be removed without replacement.'
"	(figure labels at: aLabelName) trachelShape text: aString"
]

{ #category : 'construction' }
OPElementController >> hookDiagramElement [

	"do nothing by default"

	
]

{ #category : 'diagram elements' }
OPElementController >> intendedModelOfOwningDiagramElement [

	| parentViewModel |
	parentViewModel := self viewModel parentViewModel.
	[
		parentViewModel isNotNil and: [
				parentViewModel model isNotNil and: [
						(self diagramController hasControllerForModel:
							 parentViewModel model) not ] ] ] whileTrue: [
		parentViewModel := parentViewModel parentViewModel ].

	^ parentViewModel ifNotNil: [ :parentVM | parentVM model ]
]

{ #category : 'diagram elements' }
OPElementController >> intendedOwningDiagramElement [

	| model |
	model := self intendedModelOfOwningDiagramElement.
	(model isNil or: [ model = self diagramController model ]) ifTrue: [
		^ self diagramController diagramElement ].
	^ (self diagramController controllerForModel:
		   self intendedModelOfOwningDiagramElement) diagramElement
]

{ #category : 'testing' }
OPElementController >> isCommon [
	^ false
]

{ #category : 'testing' }
OPElementController >> isDiagramOnly [

	^ false
]

{ #category : 'testing' }
OPElementController >> isHideable [

	^ true
]

{ #category : 'deprecated' }
OPElementController >> loadModel [
	self deprecated: 'Method will be removed without replacement.'
"	self model ifNil: [ self model: self createModel ].
	^ self model"
]

{ #category : 'diagram elements' }
OPElementController >> owner [

	| parentViewModel |
	parentViewModel := self viewModel parentViewModel.
	[
		parentViewModel isNotNil and: [
				parentViewModel model isNotNil and: [
						(self diagramController hasControllerForModel:
							 parentViewModel model) not ] ] ] whileTrue: [
		parentViewModel := parentViewModel parentViewModel ].

	^ self diagramController
		  controllerForModel: parentViewModel model
		  ifNone: [ nil ]
]

{ #category : 'deprecated' }
OPElementController >> registerModelEvents: aModel [
	self deprecated: 'Use model: and internalSubscribeTo: instead.'.
"	super registerModelEvents: aModel.
	aModel
		when: OPElementChanged
		do: [ :event | 
			aModel owner isNotNil & figure isNotNil
				ifTrue: [ self refreshFigure ] ]"
]

{ #category : 'construction' }
OPElementController >> registerModelIn: aParentModel [
	self 
		deprecated: 'Use viewModel registerModelIn: instead' 
		transformWith: '`@receiver registerModelIn: `@arg' -> '`@receiver viewModel registerModelIn: `@arg'.
	^ self viewModel ifNotNil: [ :vm | vm registerModelIn: aParentModel ]
]

{ #category : 'deprecated' }
OPElementController >> remove [

	self
		deprecated: 'Use #removeController instead.'
		transformWith: '`@receiver remove' -> '`@receiver removeController'.

	^ self removeControllerAndDiagramElement
]

{ #category : 'destruction' }
OPElementController >> removeDiagramElement [

	self diagramElement remove.
	self unhookDiagramElement.
	self diagramElement: nil
]

{ #category : 'destruction' }
OPElementController >> removeRender [

	super removeRender.
	self unhookRoassalShape
]

{ #category : 'construction' }
OPElementController >> renderDiagramElement [

	self diagramController willRender: self.
	self hookDiagramElement.
	self diagramElement renderIn: self diagramController canvas.
	self diagramController rendered: self.
	^ self roassalShape
]

{ #category : 'construction' }
OPElementController >> renderFigureIn: aCanvas [

	self
		deprecated: 'Use #createDiagramElement and #renderDiagramElement without parameter.'
		transformWith: '`@receiver renderFigureIn: `@statements1'
			-> '`@receiver createDiagramElement; renderDiagramElement'.
	^ self
		  createDiagramElement;
		  renderDiagramElement
]

{ #category : 'construction' }
OPElementController >> showWithoutDependentInDiagram: aDiagramController [

	self validate.
	self ensureShownDependenciesInDiagram: aDiagramController.
	aDiagramController addController: self.
	self ensureDiagramElement.
	self renderDiagramElement
]

{ #category : 'accessing' }
OPElementController >> target: aController [
	"do nothing"

	
]

{ #category : 'diagram elements' }
OPElementController >> unhookDiagramElement [

	self unhookRoassalShape
]

{ #category : 'diagram elements' }
OPElementController >> unhookRoassalShape [

	self diagramElement roassalShapeUnsubscribe: self
]

{ #category : 'event handling' }
OPElementController >> updateAfterDiagramFocused [

	self isRendered ifFalse: [ ^ self ].
	self diagramElement updateRenderFromModel
]
