Class {
	#name : #OPDiagramRemoveFigureCommand,
	#superclass : #OPDiagramFigureCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #testing }
OPDiagramRemoveFigureCommand class >> canvasShortcutActivation [
	<classAnnotation>
	^ CmdShortcutActivation by: Character delete meta for: OPCanvasPresenter
]

{ #category : #accessing }
OPDiagramRemoveFigureCommand >> defaultMenuItemName [
	^ 'Remove from model'
]

{ #category : #execution }
OPDiagramRemoveFigureCommand >> execute [
	diagramController deselectAll.
	diagramController removeFromView: figure.
	view signalUpdate
]
