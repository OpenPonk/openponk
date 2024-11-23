Class {
	#name : 'OPAbstractDiagramControllerTest',
	#superclass : 'OPBaseControllerTest',
	#category : 'OpenPonk-Core-Controllers-Tests',
	#package : 'OpenPonk-Core',
	#tag : 'Controllers-Tests'
}

{ #category : 'testing' }
OPAbstractDiagramControllerTest class >> isAbstract [

	^ self = OPAbstractDiagramControllerTest
]

{ #category : 'running' }
OPAbstractDiagramControllerTest >> setUp [

	super setUp.
	controller model: model.
	controller diagramElement: OPDiagram new.
	controller canvasPresenter: (OPCanvasPresenter new
			 canvas: RSCanvas new;
			 yourself)
]
