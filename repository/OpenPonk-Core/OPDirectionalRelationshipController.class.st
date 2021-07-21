"
A DCRelationshipController is the parent class to all line based element controllers.
"
Class {
	#name : #OPDirectionalRelationshipController,
	#superclass : #OPElementController,
	#traits : 'OPTRelationshipWithPathPointsController',
	#classTraits : 'OPTRelationshipWithPathPointsController classTrait',
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
	self figure shape ifNil: [ ^ OPElementLayout none ].
	(self figure shape isKindOf: OPRTConnection)
		ifFalse: [ ^ OPElementLayout none ].
	^ (self figure shape pathFor: self figure)
		ifNil: [ OPElementLayout none ]
		ifNotNil: [ :pathPoints | 
			OPElementLayout
				withPathFromSource: self pathSourceModel uuid
				throughPoints: pathPoints ]
]

{ #category : #accessing }
OPDirectionalRelationshipController >> layout: aLayout [
	| router innerPoints pathPoints path |
	aLayout ifNil: [ ^ self ].
	path := aLayout path.
	path ifNil: [ ^ self ].
	pathPoints := path points.
	pathPoints ifNil: [ ^ self ].
	self figure shape ifNil: [ ^ self ].
	router := self figure shape router.
	router removeAll.
	innerPoints := pathPoints size < 2
		ifTrue: [ pathPoints ]
		ifFalse: [ pathPoints copyFrom: 2 to: pathPoints size - 1 ].
	self pathSourceModel uuid = path source
		ifFalse: [ innerPoints := innerPoints reversed ].
	innerPoints do: [ :each | router addPoint: each ]
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
