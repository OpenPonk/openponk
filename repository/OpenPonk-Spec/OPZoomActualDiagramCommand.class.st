Class {
	#name : #OPZoomActualDiagramCommand,
	#superclass : #OPDiagramToolbarCommand,
	#category : #'OpenPonk-Spec-Diagram-Toolbar-Commands'
}

{ #category : #activation }
OPZoomActualDiagramCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPDiagramToolbarActivation
		byItemOf: OPDiagramToolbarBasicMenuGroup
		order: 3
		for: OPCanvasPresenter
]

{ #category : #execution }
OPZoomActualDiagramCommand >> defaultMenuIcon [
	^ OPIdeaGraphIcons actualZoomIcon
]

{ #category : #execution }
OPZoomActualDiagramCommand >> execute [
	diagramPresenter zoom: 1.0001
]
