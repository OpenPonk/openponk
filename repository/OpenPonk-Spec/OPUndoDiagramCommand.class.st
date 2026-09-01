"
Diagram toolbar command that undoes the most recent diagram action utilizing the project's autosave and memento history.
"
Class {
	#name : 'OPUndoDiagramCommand',
	#superclass : 'OPDiagramToolbarCommand',
	#category : 'OpenPonk-Spec-Commands-CanvasPresenter',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-CanvasPresenter'
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
