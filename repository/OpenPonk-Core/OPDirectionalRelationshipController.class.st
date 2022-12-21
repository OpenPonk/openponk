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

{ #category : #figures }
OPDirectionalRelationshipController >> createDiagramElement [

	super createDiagramElement.
	self diagramElement
		source: self source diagramElement;
		target: self target diagramElement
]

{ #category : #hooks }
OPDirectionalRelationshipController >> createLineFrom: fromElement to: toElement [

	self deprecated: 'This is responsibility of DI shapes now'.
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

	self deprecated:
		'Depracated without replacement - use Roassal directly or define own figures'
]

{ #category : #'canvas actions' }
OPDirectionalRelationshipController >> hideSelectionFeedback [
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

{ #category : #rendering }
OPDirectionalRelationshipController >> renderSimplified [

	diagramElement := self diagramElementClass renderSimplifiedForController: self.
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
