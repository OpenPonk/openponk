"
Diagram toolbar command that resets the camera scale of the canvas to its default, actual size (1:1 zoom).
"
Class {
	#name : 'OPZoomActualDiagramCommand',
	#superclass : 'OPDiagramToolbarCommand',
	#category : 'OpenPonk-Spec-Commands-CanvasPresenter',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-CanvasPresenter'
}

{ #category : 'activation' }
OPZoomActualDiagramCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPDiagramToolbarActivation
		byItemOf: OPDiagramToolbarBasicMenuGroup
		order: 2
		for: OPCanvasPresenter
]

{ #category : 'accessing' }
OPZoomActualDiagramCommand >> defaultMenuItemName [
	^ '100%'
]

{ #category : 'execution' }
OPZoomActualDiagramCommand >> execute [
	diagramPresenter zoom: 1.0
]
