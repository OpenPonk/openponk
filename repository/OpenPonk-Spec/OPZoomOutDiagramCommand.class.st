Class {
	#name : #OPZoomOutDiagramCommand,
	#superclass : #OPDiagramToolbarCommand,
	#category : #'OpenPonk-Spec-Diagram-Toolbar-Commands'
}

{ #category : #activation }
OPZoomOutDiagramCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPDiagramToolbarActivation
		byItemOf: OPDiagramToolbarBasicMenuGroup
		order: 2
		for: OPCanvasPresenter
]

{ #category : #execution }
OPZoomOutDiagramCommand >> defaultMenuIcon [
	^ OPIdeaGraphIcons zoomOutIcon
]

{ #category : #execution }
OPZoomOutDiagramCommand >> execute [
	diagramPresenter zoom: diagramPresenter zoom * 0.8
]
