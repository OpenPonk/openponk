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
		source: self source ensureDiagramElement;
		target: self target ensureDiagramElement
]

{ #category : #hooks }
OPDirectionalRelationshipController >> createLineFrom: fromElement to: toElement [

	self deprecated: 'This is responsibility of DI shapes now'.
]

{ #category : #construction }
OPDirectionalRelationshipController >> createModelIn: aParentModel [

	self model: self modelClass new.
	self model source: self source model.
	self model target: self target model.
	aParentModel add: self model.
	^ self model
]

{ #category : #hooks }
OPDirectionalRelationshipController >> edgeBuilder [

	self deprecated:
		'Depracated without replacement - use Roassal directly or define own figures'
]

{ #category : #accessing }
OPDirectionalRelationshipController >> modelSource [

	^ self model source
]

{ #category : #accessing }
OPDirectionalRelationshipController >> modelTarget [

	^ self model target
]

{ #category : #rendering }
OPDirectionalRelationshipController >> renderSimplified [

	diagramElement := self diagramElementClass renderSimplifiedForController: self.
]

{ #category : #accessing }
OPDirectionalRelationshipController >> source [

	^ source ifNil: [ 
		  (diagramController ifNil: [ self target diagramController ]) 
			  showInDiagramModel: self modelSource ]
]

{ #category : #accessing }
OPDirectionalRelationshipController >> source: aSourceController [
	source := aSourceController
]

{ #category : #accessing }
OPDirectionalRelationshipController >> target [

	^ target ifNil: [ 
		  (diagramController ifNil: [ self source diagramController ]) 
			  showInDiagramModel: self modelTarget ]
]

{ #category : #accessing }
OPDirectionalRelationshipController >> target: aTargetController [
	target := aTargetController
]
