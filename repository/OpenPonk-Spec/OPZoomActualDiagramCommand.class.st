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
		order: 2
		for: OPCanvasPresenter
]

{ #category : #execution }
OPZoomActualDiagramCommand >> defaultMenuIcon [
	^ nil "OPIdeaGraphIcons actualZoomIcon"
]

{ #category : #accessing }
OPZoomActualDiagramCommand >> defaultMenuItemName [
	^ '100%'
]

{ #category : #execution }
OPZoomActualDiagramCommand >> execute [
	diagramPresenter zoom: 1.0001
]
