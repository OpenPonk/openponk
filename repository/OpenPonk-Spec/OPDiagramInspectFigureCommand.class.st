Class {
	#name : #OPDiagramInspectFigureCommand,
	#superclass : #OPDiagramFigureDevCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #accessing }
OPDiagramInspectFigureCommand >> defaultMenuItemName [
	^ 'Inspect figure'
]

{ #category : #execution }
OPDiagramInspectFigureCommand >> execute [
	figure inspect
]
