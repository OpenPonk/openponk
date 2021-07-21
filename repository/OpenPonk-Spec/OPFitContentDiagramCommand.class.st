Class {
	#name : #OPFitContentDiagramCommand,
	#superclass : #OPDiagramToolbarCommand,
	#category : #'OpenPonk-Spec-Diagram-Toolbar-Commands'
}

{ #category : #activation }
OPFitContentDiagramCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPDiagramToolbarActivation
		byItemOf: OPDiagramToolbarBasicMenuGroup
		order: 4
		for: OPCanvasPresenter
]

{ #category : #execution }
OPFitContentDiagramCommand >> defaultMenuIcon [
	^ OPIdeaGraphIcons fitContentIcon
]

{ #category : #execution }
OPFitContentDiagramCommand >> defaultMenuItemName [
	^ 'Fit All'
]

{ #category : #execution }
OPFitContentDiagramCommand >> execute [
	diagramPresenter showAllFigures
]
