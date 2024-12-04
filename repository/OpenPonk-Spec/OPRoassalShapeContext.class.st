Class {
	#name : 'OPRoassalShapeContext',
	#superclass : 'CmdToolContext',
	#instVars : [
		'controllers',
		'roassalShapes'
	],
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'instance creation' }
OPRoassalShapeContext class >> for: aPresenter of: roassalShapes [

	^ (self for: aPresenter) roassalShapes: roassalShapes
]

{ #category : 'accessing' }
OPRoassalShapeContext >> canvas [
	^ self tool canvas
]

{ #category : 'accessing' }
OPRoassalShapeContext >> controllers [
	^ controllers
]

{ #category : 'accessing' }
OPRoassalShapeContext >> diagramController [
	^ self tool diagramController
]

{ #category : 'accessing' }
OPRoassalShapeContext >> diagramElements [
	^ self controllers collect: #diagramElement
]

{ #category : 'accessing' }
OPRoassalShapeContext >> models [
	^ self controllers collect: #model
]

{ #category : 'accessing' }
OPRoassalShapeContext >> plugin [
	^ self diagramController plugin
]

{ #category : 'testing' }
OPRoassalShapeContext >> representsControllers: aCollection [
	roassalShapes ifEmpty: [ ^ false ].
	^ self controllers
		allSatisfy: [ :each | aCollection anySatisfy: [ :cls | each isKindOf: cls ] ]
]

{ #category : 'testing' }
OPRoassalShapeContext >> representsModel: aModelClass [
	roassalShapes ifEmpty: [ ^ false ].
	^ self models allSatisfy: [ :each | each isKindOf: aModelClass ]
]

{ #category : 'testing' }
OPRoassalShapeContext >> representsModels: aCollection [
	roassalShapes ifEmpty: [ ^ false ].
	^ self models allSatisfy: [ :each | aCollection anySatisfy: [ :cls | each isKindOf: cls ] ]
]

{ #category : 'testing' }
OPRoassalShapeContext >> representsSimpleAnnotationUser: aToolClass [
	^ tool isKindOf: aToolClass
]

{ #category : 'accessing' }
OPRoassalShapeContext >> roassalShapes [
	^ roassalShapes
]

{ #category : 'accessing' }
OPRoassalShapeContext >> roassalShapes: aCollection [

	roassalShapes := aCollection.
	controllers := roassalShapes collect: [ :each | 
		               self diagramController controllerForRoassalShape: each ]
]
