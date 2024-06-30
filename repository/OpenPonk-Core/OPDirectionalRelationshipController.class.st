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
OPDirectionalRelationshipController >> createModelIn: aParentModel [

	self model: self modelClass new.
	self model source: self source model.
	self model target: self target model.
	aParentModel add: self model.
	^ self model
]

{ #category : 'construction' }
OPDirectionalRelationshipController >> dependingOnElements [

	^ super dependingOnElements , (Set
		   with: (self model
				    ifNil: [ self source model ]
				    ifNotNil: [ self modelSource ])
		   with: (self model
				    ifNil: [ self target model ]
				    ifNotNil: [ self modelTarget ]))
]

{ #category : 'hooks' }
OPDirectionalRelationshipController >> edgeBuilder [

	self deprecated:
		'Depracated without replacement - use Roassal directly or define own figures'
]

{ #category : 'construction' }
OPDirectionalRelationshipController >> ensureShownDependenciesInDiagram: aDiagramController [

	self ensureSourceIn: aDiagramController.
	self ensureTargetIn: aDiagramController.
	super ensureShownDependenciesInDiagram: aDiagramController
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

{ #category : 'accessing' }
OPDirectionalRelationshipController >> modelSource [

	^ model source
]

{ #category : 'accessing' }
OPDirectionalRelationshipController >> modelTarget [

	^ model target
]

{ #category : 'rendering' }
OPDirectionalRelationshipController >> renderSimplified [

	diagramElement := self diagramElementClass renderSimplifiedForController: self.
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
