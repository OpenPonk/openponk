"
A DCRelationshipController is the parent class to all line based element controllers.
"
Class {
	#name : 'OPDirectionalRelationshipController',
	#superclass : 'OPElementController',
	#traits : 'OPTRelationshipWithPathPointsController',
	#classTraits : 'OPTRelationshipWithPathPointsController classTrait',
	#instVars : [
		'source',
		'target'
	],
	#category : 'OpenPonk-Core-Controllers',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers'
}

{ #category : 'construction' }
OPDirectionalRelationshipController >> createDiagramElement [

	super createDiagramElement.
	self ensureSourceIn: diagramController.
	self ensureTargetIn: diagramController.
	^ self diagramElement
		  source: self source ensureDiagramElement;
		  target: self target ensureDiagramElement;
		  yourself
]

{ #category : 'hooks' }
OPDirectionalRelationshipController >> createLineFrom: fromElement to: toElement [

	self deprecated: 'This is responsibility of DI shapes now'.
]

{ #category : 'construction' }
OPDirectionalRelationshipController >> dependingOnElements [

	^ super dependingOnElements , (Set
		   with: ((self model
				     ifNil: [ self source model ]
				     ifNotNil: [ self modelSource ]) ifNil: [
				    self error: 'There is no source of ' , self model asString ])
		   with: ((self model
				     ifNil: [ self target model ]
				     ifNotNil: [ self modelTarget ]) ifNil: [
				    self error: 'There is no target of ' , self model asString ]))
]

{ #category : 'hooks' }
OPDirectionalRelationshipController >> edgeBuilder [

	self deprecated:
		'Depracated without replacement - use Roassal directly or define own figures'
]

{ #category : 'accessing' }
OPDirectionalRelationshipController >> ensureSourceIn: aDiagramController [

	^ source ifNil: [
		  self source:
			  (aDiagramController showWithoutDependentInDiagramModel:
				   self modelSource) ]
]

{ #category : 'accessing' }
OPDirectionalRelationshipController >> ensureTargetIn: aDiagramController [

	^ target ifNil: [
		  self target:
			  (aDiagramController showWithoutDependentInDiagramModel:
				   self modelTarget) ]
]

{ #category : 'testing' }
OPDirectionalRelationshipController >> isTargetUsedAsContainer [

	^ false
]

{ #category : 'accessing' }
OPDirectionalRelationshipController >> modelSource: aModel in: aParentModel [
	"answers whether model's source has been changed"

	self modelSource = aModel ifTrue: [ ^ false ].
	self model source: aModel.
	^ true
]

{ #category : 'accessing' }
OPDirectionalRelationshipController >> modelTarget: aModel in: aParentModel [
	"answers whether model's target has been changed"

	self modelTarget = aModel ifTrue: [ ^ false ].
	self model target: aModel.
	^ true
]

{ #category : 'construction' }
OPDirectionalRelationshipController >> registerInSourceAndTargetInContainer: aParentModel [

	self modelSource: self source model in: aParentModel.
	self modelTarget: self target model in: aParentModel
]

{ #category : 'construction' }
OPDirectionalRelationshipController >> registerModelIn: aParentModel [

	self registerInSourceAndTargetInContainer: aParentModel.
	super registerModelIn: aParentModel
]

{ #category : 'rendering' }
OPDirectionalRelationshipController >> renderSimplified [

	self diagramElement:
		(self diagramElementClass renderSimplifiedForController: self)
]

{ #category : 'construction' }
OPDirectionalRelationshipController >> showWithoutDependentInDiagram: aDiagramController [

	self ensureSourceIn: aDiagramController.
	self ensureTargetIn: aDiagramController.
	^ super showWithoutDependentInDiagram: aDiagramController
]

{ #category : 'accessing' }
OPDirectionalRelationshipController >> source [

	^ source
]

{ #category : 'accessing' }
OPDirectionalRelationshipController >> source: aSourceController [

	^ source := aSourceController
]

{ #category : 'accessing' }
OPDirectionalRelationshipController >> target [

	^ target
]

{ #category : 'accessing' }
OPDirectionalRelationshipController >> target: aTargetController [

	^ target := aTargetController
]
