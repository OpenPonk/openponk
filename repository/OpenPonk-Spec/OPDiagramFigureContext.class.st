Class {
	#name : 'OPDiagramFigureContext',
	#superclass : 'CmdToolContext',
	#instVars : [
		'figure',
		'model',
		'figures',
		'controllers'
	],
	#category : 'OpenPonk-Spec-Diagram-Figure-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Figure-Commands'
}

{ #category : 'instance creation' }
OPDiagramFigureContext class >> for: aPresenter of: figures [
	^ (self for: aPresenter) figures: figures
]

{ #category : 'accessing' }
OPDiagramFigureContext >> canvas [
	^ self tool canvas
]

{ #category : 'accessing' }
OPDiagramFigureContext >> controllers [
	^ controllers
]

{ #category : 'accessing' }
OPDiagramFigureContext >> diagramController [
	^ self tool diagramController
]

{ #category : 'accessing' }
OPDiagramFigureContext >> diagramElements [
	^ self controllers collect: #diagramElement
]

{ #category : 'accessing' }
OPDiagramFigureContext >> figures [
	^ figures
]

{ #category : 'accessing' }
OPDiagramFigureContext >> figures: aCollection [

	figures := aCollection.
	controllers := figures collect: [ :each | 
		               self diagramController controllerForRoassalShape: each ]
]

{ #category : 'accessing' }
OPDiagramFigureContext >> models [
	^ self controllers collect: #model
]

{ #category : 'accessing' }
OPDiagramFigureContext >> plugin [
	^ self diagramController plugin
]

{ #category : 'testing' }
OPDiagramFigureContext >> representsControllers: aCollection [
	figures ifEmpty: [ ^ false ].
	^ self controllers
		allSatisfy: [ :each | aCollection anySatisfy: [ :cls | each isKindOf: cls ] ]
]

{ #category : 'testing' }
OPDiagramFigureContext >> representsModel: aModelClass [
	figures ifEmpty: [ ^ false ].
	^ self models allSatisfy: [ :each | each isKindOf: aModelClass ]
]

{ #category : 'testing' }
OPDiagramFigureContext >> representsModels: aCollection [
	figures ifEmpty: [ ^ false ].
	^ self models allSatisfy: [ :each | aCollection anySatisfy: [ :cls | each isKindOf: cls ] ]
]

{ #category : 'testing' }
OPDiagramFigureContext >> representsSimpleAnnotationUser: aToolClass [
	^ tool isKindOf: aToolClass
]
