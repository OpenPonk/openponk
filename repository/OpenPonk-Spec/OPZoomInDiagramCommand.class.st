Class {
	#name : #OPZoomInDiagramCommand,
	#superclass : #OPDiagramToolbarCommand,
	#category : #'OpenPonk-Spec-Diagram-Toolbar-Commands'
}

{ #category : #activation }
OPZoomInDiagramCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPDiagramToolbarActivation
		byItemOf: OPDiagramToolbarBasicMenuGroup
		order: 1
		for: OPCanvasPresenter
]

{ #category : #execution }
OPZoomInDiagramCommand >> defaultMenuIcon [
	^ OPIdeaGraphIcons zoomInIcon
]

{ #category : #accessing }
OPZoomInDiagramCommand >> defaultMenuItemName [
	^ nil
]

{ #category : #execution }
OPZoomInDiagramCommand >> execute [
	diagramPresenter zoom: diagramPresenter zoom * 1.25
]
