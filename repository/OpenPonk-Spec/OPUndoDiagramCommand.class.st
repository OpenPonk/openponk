Class {
	#name : 'OPUndoDiagramCommand',
	#superclass : 'OPDiagramToolbarCommand',
	#category : 'OpenPonk-Spec-Diagram-Toolbar-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Toolbar-Commands'
}

{ #category : 'activation' }
OPUndoDiagramCommand class >> toolbarMenuActivation [
	"	<classAnnotation>
	^ OPDiagramToolbarActivation byRootGroupItemOrder: 10 for: OPCanvasModel"

	
]

{ #category : 'accessing' }
OPUndoDiagramCommand >> defaultMenuIconName [

	^ #smallUndo
]

{ #category : 'accessing' }
OPUndoDiagramCommand >> defaultMenuItemName [
	^ 'Undo'
]

{ #category : 'execution' }
OPUndoDiagramCommand >> execute [
	diagramPresenter diagramController undo
]
