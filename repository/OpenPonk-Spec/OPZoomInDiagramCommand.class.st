"
Diagram toolbar command that increases the camera scale (zooms in) on the active diagram canvas.
"
Class {
	#name : 'OPZoomInDiagramCommand',
	#superclass : 'OPDiagramToolbarCommand',
	#category : 'OpenPonk-Spec-Commands-CanvasPresenter',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-CanvasPresenter'
}

{ #category : 'activation' }
OPZoomInDiagramCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPDiagramToolbarActivation
		byItemOf: OPDiagramToolbarBasicMenuGroup
		order: 1
		for: OPCanvasPresenter
]

{ #category : 'accessing' }
OPZoomInDiagramCommand >> defaultMenuIconFormSet [

	^ FormSet form: OPIdeaGraphIcons zoomInIcon
]

{ #category : 'accessing' }
OPZoomInDiagramCommand >> defaultMenuItemName [
	^ ''
]

{ #category : 'execution' }
OPZoomInDiagramCommand >> execute [
	diagramPresenter zoom: diagramPresenter zoom * 1.25
]
