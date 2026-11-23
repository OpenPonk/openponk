"
Verifies headless canvas presenter accessors, controller attachment, and zoom-to-fit behavior.
"
Class {
	#name : 'OPHeadlessCanvasPresenterTest',
	#superclass : 'TestCase',
	#category : 'OpenPonk-Core-Tests-Controllers',
	#package : 'OpenPonk-Core-Tests',
	#tag : 'Controllers'
}

{ #category : 'tests' }
OPHeadlessCanvasPresenterTest >> testAccessorsAndAttachController [

	| presenter diagramController |
	presenter := OPHeadlessCanvasPresenter new.
	self assert: presenter currentCanvas identicalTo: presenter canvas.
	self assert: presenter diagramController identicalTo: nil.

	diagramController := OPTestDiagramController new.
	presenter attachController: diagramController.
	self assert: presenter diagramController identicalTo: diagramController.
	self assert: diagramController canvasPresenter identicalTo: presenter
]

{ #category : 'tests' }
OPHeadlessCanvasPresenterTest >> testZoomToFitOnEmptyAndPopulatedCanvas [

	| presenter box |
	presenter := OPHeadlessCanvasPresenter new.
	presenter canvas camera scale: 2.5.
	presenter zoomToFit.
	self assert: presenter canvas camera scale equals: 1.

	box := RSBox new
		       extent: 100 @ 50;
		       yourself.
	presenter canvas add: box.
	presenter zoomToFit.
	self assert: presenter canvas shapes size equals: 1
]
