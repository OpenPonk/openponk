"
Diagram toolbar command that adjusts the camera zoom and pan to fit all currently rendered diagram elements within the visible canvas viewport.
"
Class {
	#name : 'OPFitContentDiagramCommand',
	#superclass : 'OPDiagramToolbarCommand',
	#category : 'OpenPonk-Spec-Commands-CanvasPresenter',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-CanvasPresenter'
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
