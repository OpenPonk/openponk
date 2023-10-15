Class {
	#name : #OPDiagramFigureFontColorCommand,
	#superclass : #OPDiagramFigureColorCommand,
	#category : #'OpenPonk-Spec-Diagram-Figure-Commands'
}

{ #category : #accessing }
OPDiagramFigureFontColorCommand class >> colorAttribute [

	^ #fontColor
]

{ #category : #activation }
OPDiagramFigureFontColorCommand class >> contextMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation
		  byItemOf: OPFigureFontColorMenuGroup
		  for: OPCanvasPresenter
]
