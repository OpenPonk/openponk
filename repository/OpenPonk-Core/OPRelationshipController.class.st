"
A DCRelationshipController is the parent class to all line based element controllers.
"
Class {
	#name : #OPRelationshipController,
	#superclass : #OPElementController,
	#instVars : [
		'source',
		'target'
	],
	#category : #'OpenPonk-Core-Controllers'
}

{ #category : #hooks }
OPRelationshipController >> connectionFeedback [
	^ OPInteractiveLine new
		lineBuilder: [ :fromFigure :toFigure | self edgeBuilder createEdgeFrom: fromFigure to: toFigure ];
		from: source figure
]

{ #category : #hooks }
OPRelationshipController >> createEdgeFrom: fromElement to: toElement [
	^ OPRTCallbackBuilder block: [ :view | self edgeBuilder createFigureFrom: fromElement to: toElement view: view ]
]

{ #category : #figures }
OPRelationshipController >> createFigure [
	^ self createEdgeFrom: source figure to: target figure
]

{ #category : #hooks }
OPRelationshipController >> createModel [
	self model ifNotNil: [ ^ self model ].
	^ self modelClass from: source model to: target model
]

{ #category : #hooks }
OPRelationshipController >> edgeBuilder [
	^ self subclassResponsibility
]

{ #category : #'canvas actions' }
OPRelationshipController >> hideSelectionFeedback [
	"by default do nothing"

	
]

{ #category : #accessing }
OPRelationshipController >> layout [
	^ nil
]

{ #category : #accessing }
OPRelationshipController >> layout: anObject [
	"by default do nothing"
]

{ #category : #'canvas actions' }
OPRelationshipController >> showAcceptFeedbackFor: aController [
	"Return something that understands #remove, or nil to not show any feedback."

	^ OPAcceptDenyFeedbackBuilder acceptFeedbackFor: self figure
]

{ #category : #'canvas actions' }
OPRelationshipController >> showDenyFeedbackFor: aController [
	"Return something that understands #remove, or nil to not show any feedback."

	^ OPAcceptDenyFeedbackBuilder denyFeedbackFor: self figure
]

{ #category : #'canvas actions' }
OPRelationshipController >> showSelectionFeedback [
	"by default do nothing"

	
]

{ #category : #accessing }
OPRelationshipController >> source [
	^ source
]

{ #category : #accessing }
OPRelationshipController >> source: aSourceController [
	source := aSourceController
]

{ #category : #accessing }
OPRelationshipController >> target: aTargetController [
	target := aTargetController
]
