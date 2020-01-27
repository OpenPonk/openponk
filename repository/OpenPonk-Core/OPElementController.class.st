"
A DCElementController an abstract class which should be a parent for all elements in diagram, such as classes, states.
It has method which handles the creation of the form for specific element. The controller is also responsible for specification of the view of an element. The precise definition of the form and the view is done by descendants.
"
Class {
	#name : #OPElementController,
	#superclass : #OPController,
	#instVars : [
		'figure'
	],
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
	aParentModel add: model.
	^ model
]

{ #category : #construction }
OPElementController >> createModelIn: aParentModel andShowInDiagram: aDiagramController [
	self createModelIn: aParentModel.
	self showInDiagram: aDiagramController
]

{ #category : #accessing }
OPElementController >> figure [
	^ figure
]

{ #category : #accessing }
OPElementController >> figure: aFigure [
	figure := aFigure
]

{ #category : #deprecated }
OPElementController >> figureLabel: aLabelName text: aString [
	self deprecated: 'Method will be removed without replacement.'
"	(figure labels at: aLabelName) trachelShape text: aString"
]

{ #category : #'canvas actions' }
OPElementController >> hideSelectionFeedback [
	self figure view
		ifNotNil: [ 
			self figure announce: OPTRUnfocused.
			self figure view signalUpdate ]
]

{ #category : #accessing }
OPElementController >> layout [
	^ self figure position
]

{ #category : #accessing }
OPElementController >> layout: aPoint [
	self figure translateTo: aPoint
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
	self deprecated: 'Use #removeController instead.'
"	super remove.
	self removeFigure"
]

{ #category : #'ui interaction' }
OPElementController >> reselect [
	self diagramController ifNotNil: [ self diagramController selectController: self ]
]

{ #category : #construction }
OPElementController >> showInDiagram: aDiagramController [
	aDiagramController addController: self.
	self renderFigureIn: aDiagramController view.
	self elementsToShowInside
		do: [ :each | 
			(aDiagramController newControllerFor: each)
				showInDiagram: aDiagramController ]
]

{ #category : #'canvas actions' }
OPElementController >> showSelectionFeedback [
	self figure announce: OPTRFocused
]

{ #category : #construction }
OPElementController >> showWithDependentInDiagram: aDiagramController [
	aDiagramController addController: self.
	self renderFigureIn: aDiagramController view.
	self dependentElements
		do: [ :each | 
			(aDiagramController newControllerFor: each)
				showWithDependentInDiagram: aDiagramController ]
]

{ #category : #accessing }
OPElementController >> target: aController [
	"do nothing"

	
]
