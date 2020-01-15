Class {
	#name : #OPZoomInDiagramCommand,
	#superclass : #OPDiagramToolbarCommand,
	#category : 'OpenPonk-Spec-Diagram-Toolbar-Commands'
}

{ #category : #activation }
OPZoomInDiagramCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPDiagramToolbarActivation
		byItemOf: OPDiagramToolbarBasicMenuGroup
		order: 1
		for: OPCanvasModel
]

{ #category : #execution }
OPZoomInDiagramCommand >> defaultMenuIcon [
	^ OPIdeaGraphIcons zoomInIcon
]

{ #category : #execution }
OPZoomInDiagramCommand >> execute [
	diagramPresenter zoom: diagramPresenter zoom * 1.25
]
