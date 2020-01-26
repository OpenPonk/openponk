Class {
	#name : #OPDiagramFigureContext,
	#superclass : #CmdToolContext,
	#instVars : [
		'figure',
		'model',
		'figures',
		'controllers'
	],
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #'instance creation' }
OPDiagramFigureContext class >> for: aPresenter of: figures [
	^ (self for: aPresenter) figures: figures
]

{ #category : #accessing }
OPDiagramFigureContext >> controller [
	^ self diagramController controllerForFigure: self figure
]

{ #category : #accessing }
OPDiagramFigureContext >> controllers [
	^ controllers
]

{ #category : #accessing }
OPDiagramFigureContext >> diagramController [
	^ self tool diagramController
]

{ #category : #accessing }
OPDiagramFigureContext >> figure [
	^ figures first
]

{ #category : #accessing }
OPDiagramFigureContext >> figures [
	^ figures
]

{ #category : #accessing }
OPDiagramFigureContext >> figures: aCollection [
	figures := aCollection.
	controllers := self diagramController controllers
		select: [ :each | figures includes: each figure ]
]

{ #category : #accessing }
OPDiagramFigureContext >> model [
	^ self controller model
]

{ #category : #accessing }
OPDiagramFigureContext >> models [
	^ self controllers collect: #model
]

{ #category : #accessing }
OPDiagramFigureContext >> plugin [
	^ self diagramController plugin
]

{ #category : #testing }
OPDiagramFigureContext >> representsControllers: aCollection [
	figures ifEmpty: [ ^ false ].
	^ self controllers
		allSatisfy: [ :each | aCollection anySatisfy: [ :cls | each isKindOf: cls ] ]
]

{ #category : #testing }
OPDiagramFigureContext >> representsModel: aModelClass [
	figures ifEmpty: [ ^ false ].
	^ self models allSatisfy: [ :each | each isKindOf: aModelClass ]
]

{ #category : #testing }
OPDiagramFigureContext >> representsModels: aCollection [
	figures ifEmpty: [ ^ false ].
	^ self models allSatisfy: [ :each | aCollection anySatisfy: [ :cls | each isKindOf: cls ] ]
]

{ #category : #testing }
OPDiagramFigureContext >> representsSimpleAnnotationUser: aToolClass [
	^ tool isKindOf: aToolClass
]

{ #category : #accessing }
OPDiagramFigureContext >> view [
	^ self tool view
]
