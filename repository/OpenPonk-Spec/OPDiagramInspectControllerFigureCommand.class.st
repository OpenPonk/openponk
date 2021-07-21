Class {
	#name : #OPDiagramInspectControllerFigureCommand,
	#superclass : #OPDiagramFigureDevCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #testing }
OPDiagramInspectControllerFigureCommand class >> canvasShortcutActivation [
	<classAnnotation>
	^ CmdShortcutActivation by: $i shift meta for: OPCanvasPresenter
]

{ #category : #accessing }
OPDiagramInspectControllerFigureCommand >> defaultMenuItemName [
	^ 'Inspect controller'
]

{ #category : #execution }
OPDiagramInspectControllerFigureCommand >> execute [
	(diagramController controllerForFigure: figure) inspect
]
