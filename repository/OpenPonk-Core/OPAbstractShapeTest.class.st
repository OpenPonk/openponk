Class {
	#name : 'OPAbstractShapeTest',
	#superclass : 'TestCase',
	#instVars : [
		'canvas',
		'shape'
	],
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'testing' }
OPAbstractShapeTest class >> isAbstract [
	^ self name includesSubstring: 'Abstract'
]

{ #category : 'instance creation' }
OPAbstractShapeTest >> newShapeInstance [
	^ self shapeClass new
]

{ #category : 'running' }
OPAbstractShapeTest >> setUp [

	super setUp.
	shape := self newShapeInstance.
	canvas := RSCanvas new
]

{ #category : 'hooks' }
OPAbstractShapeTest >> shapeClass [
	^ self subclassResponsibility
]

{ #category : 'tests' }
OPAbstractShapeTest >> testRenderSimplifiedForController [

	| diagramController controller |
	canvas := RSCanvas new.

	diagramController := Mock new.
	diagramController stub canvas willReturn: canvas.

	controller := Mock new.
	controller stub diagramController willReturn: diagramController.

	self shapeClass renderSimplifiedForController: controller.

	self assert: canvas shapes isNotEmpty
]
