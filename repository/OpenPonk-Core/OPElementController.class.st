"
A DCElementController an abstract class which should be a parent for all elements in diagram, such as classes, states.
It has method which handles the creation of the form for specific element. The controller is also responsible for specification of the view of an element. The precise definition of the form and the view is done by descendants.
"
Class {
	#name : 'OPElementController',
	#superclass : 'OPController',
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPElementController >> createDiagramElement [

	^ self diagramElement: (self diagramElementClass
			   in: self ownerDiagramElement
			   forModelElement: self model)
]

{ #category : 'construction' }
OPElementController >> createModelIn: aParentModel [

	self model: self modelClass new.
	self registerModelIn: aParentModel.
	^ self model
]

{ #category : 'construction' }
OPElementController >> createModelIn: aParentModel andShowInDiagram: aDiagramController [

	self removeDiagramElement.
	self createModelIn: aParentModel.
	self showWithoutDependentInDiagram: aDiagramController
]

{ #category : 'construction' }
OPElementController >> dependingOnElements [

	^ Set empty
]

{ #category : 'construction' }
OPElementController >> diagramElementClass [

	^ self subclassResponsibility
]

{ #category : 'diagram elements' }
OPElementController >> diagramElementOwnerWithPossibleController [

	^ self diagramElement owningElementWithPossibleController
]

{ #category : 'ui interaction' }
OPElementController >> ensureDeselected [

	| roassalShape |
	self isRendered ifFalse: [ ^ self ].
	roassalShape := self roassalShape.
	roassalShape isSelectable ifFalse: [ ^ self ].
	roassalShape isSelected ifFalse: [ ^ self ].
	roassalShape
		propertyAt: OPRSSelectable
		ifPresent: [ :selectable | selectable fakeClicked: roassalShape ]
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

	^ self dependingOnElements do: [ :each |
		  aDiagramController showWithoutDependentInDiagramModel: each ]
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

	^ self diagramController
]

{ #category : 'diagram elements' }
OPElementController >> ownerDiagramElement [

	^ self owner diagramElement
]

{ #category : 'connecting' }
OPElementController >> parentContainerModel [
	"Redefine to answer model that acts as a primary container of my model and other elements on my model's level. If I am always directly inside diagramController without any intermediate structure, this may answer self diagramController model"

	^ self model owner
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

	self registerModelInContainer: aParentModel
]

{ #category : 'construction' }
OPElementController >> registerModelInContainer: aParentModel [

	aParentModel add: self model
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

	"do nothing by default"

	
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
