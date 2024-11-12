Class {
	#name : 'OPAbstractDiagramElementTest',
	#superclass : 'TestCase',
	#instVars : [
		'canvas',
		'shape',
		'model'
	],
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'testing' }
OPAbstractDiagramElementTest class >> isAbstract [
	^ self name includesSubstring: 'Abstract'
]

{ #category : 'instance creation' }
OPAbstractDiagramElementTest >> modelClass [

	^ self subclassResponsibility
]

{ #category : 'instance creation' }
OPAbstractDiagramElementTest >> newModelInstance [

	^ self modelClass new
]

{ #category : 'instance creation' }
OPAbstractDiagramElementTest >> newShapeInstance [
	^ self shapeClass new
]

{ #category : 'running' }
OPAbstractDiagramElementTest >> setUp [

	super setUp.
	shape := self newShapeInstance.
	model := self newModelInstance.
	shape modelElement: model.
	canvas := RSCanvas new
]

{ #category : 'hooks' }
OPAbstractDiagramElementTest >> shapeClass [
	^ self subclassResponsibility
]

{ #category : 'running' }
OPAbstractDiagramElementTest >> testEmpty [

	self assert: shape modelElement equals: model.
	self assertCollection: shape modelElements hasSameElements: { model }
]

{ #category : 'tests' }
OPAbstractDiagramElementTest >> testRenderSimplifiedForController [

	| diagramController controller |
	canvas := RSCanvas new.

	diagramController := Mock new.
	diagramController stub canvas willReturn: canvas.

	controller := Mock new.
	controller stub diagramController willReturn: diagramController.

	self shapeClass renderSimplifiedForController: controller.

	self assert: canvas shapes isNotEmpty
]
