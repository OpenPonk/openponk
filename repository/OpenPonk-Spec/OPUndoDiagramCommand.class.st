Class {
	#name : #OPUndoDiagramCommand,
	#superclass : #OPDiagramToolbarCommand,
	#category : #'OpenPonk-Spec-Diagram-Toolbar-Commands'
}

{ #category : #activation }
OPUndoDiagramCommand class >> toolbarMenuActivation [
	"	<classAnnotation>
	^ OPDiagramToolbarActivation byRootGroupItemOrder: 10 for: OPCanvasModel"

	
]

{ #category : #execution }
OPUndoDiagramCommand >> defaultMenuIcon [
	^ Smalltalk ui icons smallUndo
]

{ #category : #accessing }
OPUndoDiagramCommand >> defaultMenuItemName [
	^ 'Undo'
]

{ #category : #execution }
OPUndoDiagramCommand >> execute [
	diagramPresenter diagramController undo
]
