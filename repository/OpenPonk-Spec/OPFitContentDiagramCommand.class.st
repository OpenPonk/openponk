Class {
	#name : 'OPFitContentDiagramCommand',
	#superclass : 'OPDiagramToolbarCommand',
	#category : 'OpenPonk-Spec-Diagram-Toolbar-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Toolbar-Commands'
}

{ #category : 'activation' }
OPFitContentDiagramCommand class >> toolbarMenuActivation [
	<classAnnotation>
	^ OPDiagramToolbarActivation
		byItemOf: OPDiagramToolbarBasicMenuGroup
		order: 4
		for: OPCanvasPresenter
]

{ #category : 'accessing' }
OPFitContentDiagramCommand >> defaultMenuIconFormSet [

	^ FormSet form: OPIdeaGraphIcons fitContentIcon
]

{ #category : 'accessing' }
OPFitContentDiagramCommand >> defaultMenuItemName [
	^ 'Fit All'
]

{ #category : 'execution' }
OPFitContentDiagramCommand >> execute [
	diagramPresenter zoomToFit
]
