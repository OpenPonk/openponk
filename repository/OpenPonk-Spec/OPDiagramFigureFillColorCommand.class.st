Class {
	#name : 'OPDiagramFigureFillColorCommand',
	#superclass : 'OPDiagramFigureColorCommand',
	#category : 'OpenPonk-Spec-Diagram-Figure-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Figure-Commands'
}

{ #category : 'accessing' }
OPDiagramFigureFillColorCommand class >> colorAttribute [

	^ #fillColor
]

{ #category : 'as yet unclassified' }
OPDiagramFigureFillColorCommand class >> contextMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation
		  byItemOf: OPFigureFillColorMenuGroup
		  for: OPCanvasPresenter
]
