"
Diagram toolbar command that re-applies the most recently undone diagram action via the project's autosave/memento manager.
"
Class {
	#name : 'OPRedoDiagramCommand',
	#superclass : 'OPDiagramToolbarCommand',
	#category : 'OpenPonk-Spec-Commands-CanvasPresenter',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-CanvasPresenter'
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
