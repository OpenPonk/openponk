Class {
	#name : 'OPZoomInDiagramCommand',
	#superclass : 'OPDiagramToolbarCommand',
	#category : 'OpenPonk-Spec-Diagram-Toolbar-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Toolbar-Commands'
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
