Class {
	#name : #OPDiagramFigureStrokeColorCommand,
	#superclass : #OPDiagramFigureColorCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #accessing }
OPDiagramFigureStrokeColorCommand class >> colorAttribute [

	^ #strokeColor
]

{ #category : #activation }
OPDiagramFigureStrokeColorCommand class >> contextMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation
		  byItemOf: OPFigureStrokeColorMenuGroup
		  for: OPCanvasPresenter
]
