Class {
	#name : 'OPDiagramFigureStrokeColorCommand',
	#superclass : 'OPDiagramFigureColorCommand',
	#category : 'OpenPonk-Spec-Diagram-Figure-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-Figure-Commands'
}

{ #category : 'accessing' }
OPDiagramFigureStrokeColorCommand class >> colorAttribute [

	^ #strokeColor
]

{ #category : 'activation' }
OPDiagramFigureStrokeColorCommand class >> contextMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation
		  byItemOf: OPFigureStrokeColorMenuGroup
		  for: OPCanvasPresenter
]

{ #category : 'as yet unclassified' }
OPDiagramFigureStrokeColorCommand class >> defaultColorOf: aDiagramElement [

	^ aDiagramElement defaultStrokeColor
]
