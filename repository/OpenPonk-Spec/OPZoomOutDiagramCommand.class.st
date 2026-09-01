"
Diagram toolbar command that decreases the camera scale (zooms out) on the active diagram canvas.
"
Class {
	#name : 'OPZoomOutDiagramCommand',
	#superclass : 'OPDiagramToolbarCommand',
	#category : 'OpenPonk-Spec-Commands-CanvasPresenter',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-CanvasPresenter'
}

{ #category : 'activation' }
OPZoomOutDiagramCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPDiagramToolbarActivation
		byItemOf: OPDiagramToolbarBasicMenuGroup
		order: 3
		for: OPCanvasPresenter
]

{ #category : 'accessing' }
OPZoomOutDiagramCommand >> defaultMenuIconFormSet [

	^ FormSet form: OPIdeaGraphIcons zoomOutIcon
]

{ #category : 'accessing' }
OPZoomOutDiagramCommand >> defaultMenuItemName [
	^ ''
]

{ #category : 'execution' }
OPZoomOutDiagramCommand >> execute [
	diagramPresenter zoom: diagramPresenter zoom * 0.8
]
