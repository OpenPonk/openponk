Class {
	#name : 'OPZoomOutDiagramCommand',
	#superclass : 'OPDiagramToolbarCommand',
	#category : 'OpenPonk-Spec-Diagram-Toolbar-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Toolbar-Commands'
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
