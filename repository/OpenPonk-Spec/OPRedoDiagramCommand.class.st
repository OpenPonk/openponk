Class {
	#name : 'OPRedoDiagramCommand',
	#superclass : 'OPDiagramToolbarCommand',
	#category : 'OpenPonk-Spec-Diagram-Toolbar-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Toolbar-Commands'
}

{ #category : 'activation' }
OPRedoDiagramCommand class >> toolbarMenuActivation [
	"<classAnnotation>
	^ OPDiagramToolbarActivation byRootGroupItemOrder: 11 for: OPCanvasModel"
]

{ #category : 'accessing' }
OPRedoDiagramCommand >> defaultMenuIconName [

	^ #smallRedo
]

{ #category : 'accessing' }
OPRedoDiagramCommand >> defaultMenuItemName [
	^ 'Redo'
]

{ #category : 'execution' }
OPRedoDiagramCommand >> execute [
		 diagramPresenter diagramController redo
]
