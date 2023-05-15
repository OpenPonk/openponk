"
A DCElementController an abstract class which should be a parent for all elements in diagram, such as classes, states.
It has method which handles the creation of the form for specific element. The controller is also responsible for specification of the view of an element. The precise definition of the form and the view is done by descendants.
"
Class {
	#name : #OPElementController,
	#superclass : #OPController,
	#category : #'OpenPonk-Core-Controllers'
}

{ #category : #deprecated }
OPElementController >> attach [
	self deprecated: 'Use createInModel:andShowInDiagram: instead.'.
"	self registerModelEvents: model.
	self attachFigure"
]

{ #category : #deprecated }
OPElementController >> attachFigure [
	"add figure to the view"

	self deprecated: 'Use createInModel:andShowInDiagram: instead.'
	"
	| newFigure |
	newFigure := self figure.
	newFigure view ifNil: [ newFigure renderIn: self diagramController view ].
	self diagramController figureAdded: newFigure.
	self refreshFigure"
]

{ #category : #deprecated }
OPElementController >> attachTo: aDiagramController [
	self deprecated: 'Use createInModel:andShowInDiagram: instead.'.
	"self diagramController: aDiagramController.
	aDiagramController controllers add: self.

	self loadModel.
	self registerModelEvents: model.
	self attachFigure"
]

{ #category : #construction }
OPElementController >> createDiagramElement [

	diagramElement := self diagramElementClass
		                  in: self diagramElementOwner
		                  forModelElement: self model
]

{ #category : #deprecated }
OPElementController >> createFigure [
	self deprecated: 'Use renderFigureIn: instead.'.

"	^ OPRTCallbackBuilder block: [ :view | self createFigureInView: view ]"
]

{ #category : #deprecated }
OPElementController >> createModel [
	self deprecated: 'Use createModelIn: instead.'
"	^ self model ifNil: [ self modelClass new ]"
]

{ #category : #construction }
OPElementController >> createModelIn: aParentModel [

	self model: self modelClass new.
	aParentModel add: self model.
	^ self model
]

{ #category : #construction }
OPElementController >> createModelIn: aParentModel andShowInDiagram: aDiagramController [

	self removeDiagramElement.
	self createModelIn: aParentModel.
	self showWithoutDependentInDiagram: aDiagramController
]

{ #category : #construction }
OPElementController >> diagramElementClass [

	^ self subclassResponsibility
]

{ #category : #'as yet unclassified' }
OPElementController >> diagramElementOwner [

	^ self diagramController diagramElement
]

{ #category : #accessing }
OPElementController >> ensureDiagramElement [

	diagramElement
		ifNil: [ self createDiagramElement ]
		ifNotNil: [ self linkToExistingDiagramElement ].
	^ diagramElement
]

{ #category : #figures }
OPElementController >> figure: aFigure [

	self deprecated:
		'Figure (Roassal shape) cannot be set directly anymore.'
]

{ #category : #deprecated }
OPElementController >> figureLabel: aLabelName text: aString [
	self deprecated: 'Method will be removed without replacement.'
"	(figure labels at: aLabelName) trachelShape text: aString"
]

{ #category : #accessing }
OPElementController >> hookDiagramElement [

	"do nothing by default"

	
]

{ #category : #testing }
OPElementController >> isCommon [
	^ false
]

{ #category : #testing }
OPElementController >> isRendered [

	^ self diagramElement isNotNil and: [ self diagramElement isRendered ]
]

{ #category : #construction }
OPElementController >> linkToExistingDiagramElement [

	self diagramElement modelElement: self model
]

{ #category : #deprecated }
OPElementController >> loadModel [
	self deprecated: 'Method will be removed without replacement.'
"	self model ifNil: [ self model: self createModel ].
	^ self model"
]

{ #category : #deprecated }
OPElementController >> registerModelEvents: aModel [
	self deprecated: 'Use model: and internalSubscribeTo: instead.'.
"	super registerModelEvents: aModel.
	aModel
		when: OPElementChanged
		do: [ :event | 
			aModel owner isNotNil & figure isNotNil
				ifTrue: [ self refreshFigure ] ]"
]

{ #category : #deprecated }
OPElementController >> remove [

	self
		deprecated: 'Use #removeController instead.'
		transformWith: '`@receiver remove' -> '`@receiver removeController'.

	^ self removeController
]

{ #category : #construction }
OPElementController >> renderDiagramElement [

	self diagramController willRender: self.
	self hookDiagramElement.
	self diagramElement renderIn: self diagramController canvas.
	self diagramController rendered: self.
	^ self roassalShape
]

{ #category : #construction }
OPElementController >> renderFigureIn: aCanvas [

	self
		deprecated: 'Use #createDiagramElement and #renderDiagramElement without parameter.'
		transformWith: '`@receiver renderFigureIn: `@statements1'
			-> '`@receiver createDiagramElement; renderDiagramElement'.
	^ self
		  createDiagramElement;
		  renderDiagramElement
]

{ #category : #construction }
OPElementController >> showInDiagram: aDiagramController [

	aDiagramController addController: self.
	self ensureDiagramElement.
	self renderDiagramElement.
	self dependentElements do: [ :each | 
		aDiagramController showInDiagramModel: each ]
]

{ #category : #construction }
OPElementController >> showWithoutDependentInDiagram: aDiagramController [

	aDiagramController addController: self.
	self ensureDiagramElement.
	self renderDiagramElement
]

{ #category : #accessing }
OPElementController >> target: aController [
	"do nothing"

	
]
