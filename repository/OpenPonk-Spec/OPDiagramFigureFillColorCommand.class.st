Class {
	#name : 'OPDiagramFigureFillColorCommand',
	#superclass : 'OPRoassalShapeColorCommand',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'accessing' }
OPDiagramFigureFillColorCommand class >> colorAttribute [

	^ #fillColor
]

{ #category : 'as yet unclassified' }
OPDiagramFigureFillColorCommand class >> contextMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation
		  byItemOf: OPRoassalShapeFillColorMenuGroup
		  for: OPCanvasPresenter
]

{ #category : 'as yet unclassified' }
OPDiagramFigureFillColorCommand class >> defaultColorOf: aDiagramElement [

	^ aDiagramElement defaultFillColor
]
