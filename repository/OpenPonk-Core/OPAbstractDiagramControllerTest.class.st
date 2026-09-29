"
Abstract base class for testing diagram controllers. 
Extends OPBaseControllerTest to provide specific scaffolding for controllers that govern an entire diagram space.
"
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
	| project projectController |
	super setUp.
	project := OPProject new.
	model ifNotNil: [ :activeModel | project addModel: activeModel ].
	projectController := OPProjectController forProject: project.
	projectController addDiagramController: controller.
	controller model: model.
	controller diagramElement: (OPOpenPonkDiagram forModelElement: model).
	controller canvasPresenter: (OPCanvasPresenter new
		canvas: RSCanvas new;
		yourself)
]
