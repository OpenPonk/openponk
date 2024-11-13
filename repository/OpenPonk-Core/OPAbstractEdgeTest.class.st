Class {
	#name : 'OPAbstractEdgeTest',
	#superclass : 'OPAbstractDiagramElementTest',
	#category : 'OpenPonk-Core-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Tests'
}

{ #category : 'tests' }
OPAbstractEdgeTest >> testRenderSimplifiedForController [

	| diagramController controller connectedController rsBox connectedShape |
	canvas := RSCanvas new.

	diagramController := Mock new.
	diagramController stub canvas willReturn: canvas.
	
	rsBox := RSBox new.
	
	connectedShape := OPDiagramElement new.
	connectedShape stub roassalShape willReturn: rsBox.
	
	connectedController := Mock new.
	connectedController stub diagramElement willReturn: connectedShape.
	

	controller := Mock new.
	controller stub diagramController willReturn: diagramController.
	controller stub source willReturn: connectedController.
	controller stub target willReturn: connectedController.

	self shapeClass renderSimplifiedForController: controller.

	self assert: canvas shapes isNotEmpty
]
