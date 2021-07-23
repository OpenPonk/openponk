Class {
	#name : #OPRedoDiagramCommand,
	#superclass : #OPDiagramToolbarCommand,
	#category : #'OpenPonk-Spec-Diagram-Toolbar-Commands'
}

{ #category : #activation }
OPRedoDiagramCommand class >> toolbarMenuActivation [
	"<classAnnotation>
	^ OPDiagramToolbarActivation byRootGroupItemOrder: 11 for: OPCanvasModel"
]

{ #category : #execution }
OPRedoDiagramCommand >> defaultMenuIcon [

	^ self iconNamed: #smallRedo
]

{ #category : #accessing }
OPRedoDiagramCommand >> defaultMenuItemName [
	^ 'Redo'
]

{ #category : #execution }
OPRedoDiagramCommand >> execute [
		 diagramPresenter diagramController redo
]
