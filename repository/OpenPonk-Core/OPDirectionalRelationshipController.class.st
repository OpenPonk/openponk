"
A DCRelationshipController is the parent class to all line based element controllers.
"
Class {
	#name : #OPDirectionalRelationshipController,
	#superclass : #OPElementController,
	#instVars : [
		'source',
		'target'
	],
	#category : #'OpenPonk-Core-Controllers'
}

{ #category : #hooks }
OPDirectionalRelationshipController >> connectionFeedback [
	^ OPInteractiveLine new
		lineBuilder:
				[ :fromFigure :toFigure | self createEdgeFrom: fromFigure to: toFigure ];
		from: source figure
]

{ #category : #hooks }
OPDirectionalRelationshipController >> createEdgeFrom: fromElement to: toElement [
	^ self subclassResponsibility
]

{ #category : #construction }
OPDirectionalRelationshipController >> createModelIn: aParentModel [
	self model: self modelClass new.
	model source: self source model.
	model target: self target model.
	aParentModel add: model.
	^ model
]

{ #category : #hooks }
OPDirectionalRelationshipController >> edgeBuilder [
	self
		deprecated:
			'Depracated without replacement - use Roassal directly or define own figures'.
	^ self subclassResponsibility
]

{ #category : #'canvas actions' }
OPDirectionalRelationshipController >> hideSelectionFeedback [
	"by default do nothing"

	
]

{ #category : #accessing }
OPDirectionalRelationshipController >> layout [
	^ nil
]

{ #category : #accessing }
OPDirectionalRelationshipController >> layout: anObject [
	"by default do nothing"
]

{ #category : #accessing }
OPDirectionalRelationshipController >> modelSource [
	^ model source
]

{ #category : #accessing }
OPDirectionalRelationshipController >> modelTarget [
	^ model target
]

{ #category : #'canvas actions' }
OPDirectionalRelationshipController >> showAcceptFeedbackFor: aController [
	"Return something that understands #remove, or nil to not show any feedback."

	^ OPAcceptDenyFeedbackBuilder acceptFeedbackFor: self figure
]

{ #category : #'canvas actions' }
OPDirectionalRelationshipController >> showDenyFeedbackFor: aController [
	"Return something that understands #remove, or nil to not show any feedback."

	^ OPAcceptDenyFeedbackBuilder denyFeedbackFor: self figure
]

{ #category : #'canvas actions' }
OPDirectionalRelationshipController >> showSelectionFeedback [
	"by default do nothing"

	
]

{ #category : #accessing }
OPDirectionalRelationshipController >> source [
	^ source
		ifNil: [ diagramController controllerForModel: self modelSource ]
]

{ #category : #accessing }
OPDirectionalRelationshipController >> source: aSourceController [
	source := aSourceController
]

{ #category : #accessing }
OPDirectionalRelationshipController >> target [
	^ target
		ifNil: [ (diagramController ifNil: [ self source diagramController ])
				controllerForModel: self modelTarget ]
]

{ #category : #accessing }
OPDirectionalRelationshipController >> target: aTargetController [
	target := aTargetController
]
