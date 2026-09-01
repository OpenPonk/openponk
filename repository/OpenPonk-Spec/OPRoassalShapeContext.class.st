"
Represents the execution context for Commander tools when a user interacts with one or more Roassal shapes. 
Bundles the canvas, selected shapes, and their associated domain models and controllers.
"
Class {
	#name : 'OPRoassalShapeContext',
	#superclass : 'CmdToolContext',
	#instVars : [
		'controllers',
		'roassalShapes'
	],
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
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

	^ self controllers collect: [ :eachController |
		  eachController viewModel model ]
]

{ #category : 'accessing' }
OPRoassalShapeContext >> plugin [
	^ self diagramController plugin
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

{ #category : 'accessing' }
OPRoassalShapeContext >> viewModels [
	^ self controllers collect: #viewModel
]
