"
Abstract base controller for directional relationship elements. 
Manages the visual connection (edge) between a source and a target, coordinating with the respective view models and the underlying path routing.
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

{ #category : 'construction' }
OPDirectionalRelationshipController >> createModelIn: aParentModel [

	self viewModel: (self viewModelRegistry
			 registerNewViewModelOfClass: self class viewModelClass
			 createdBy: [ :newViewModel |
					 newViewModel
						 createModelFrom: self source viewModel
						 to: self target viewModel
						 in: aParentModel ]).
	^ self model
]

{ #category : 'construction' }
OPDirectionalRelationshipController >> ensureShownDependenciesInDiagram: aDiagramController [

	self ensureSourceIn: aDiagramController.
	self ensureTargetIn: aDiagramController.
	^ super ensureShownDependenciesInDiagram: aDiagramController
]

{ #category : 'accessing' }
OPDirectionalRelationshipController >> ensureSourceIn: aDiagramController [

	^ source ifNil: [
			  self source:
				  (aDiagramController showWithoutDependentInDiagramModel:
					   self viewModel modelSource) ]
]

{ #category : 'accessing' }
OPDirectionalRelationshipController >> ensureTargetIn: aDiagramController [

	^ target ifNil: [
			  self target:
				  (aDiagramController showWithoutDependentInDiagramModel:
					   self viewModel modelTarget) ]
]

{ #category : 'testing' }
OPDirectionalRelationshipController >> isTargetUsedAsContainer [

	^ false
]

{ #category : 'accessing' }
OPDirectionalRelationshipController >> modelSource [
	self
		deprecated: 'Use viewModel instead'
		transformWith: '`@receiver modelSource' -> '`@receiver viewModel modelSource'.
	^ self viewModel modelSource
]

{ #category : 'accessing' }
OPDirectionalRelationshipController >> modelTarget [
	self
		deprecated: 'Use viewModel instead'
		transformWith: '`@receiver modelTarget' -> '`@receiver viewModel modelTarget'.
	^ self viewModel modelTarget
]

{ #category : 'rendering' }
OPDirectionalRelationshipController >> renderSimplified [

	self diagramElement:
		(self diagramElementClass renderSimplifiedForController: self)
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
