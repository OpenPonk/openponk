Class {
	#name : 'OPDiagramFigureFontColorCommand',
	#superclass : 'OPRoassalShapeColorCommand',
	#category : 'OpenPonk-Spec-Diagram-RoassalShape-Commands',
	#package : 'OpenPonk-Spec',
	#tag : 'Diagram-RoassalShape-Commands'
}

{ #category : 'accessing' }
OPDiagramFigureFontColorCommand class >> colorAttribute [

	^ #fontColor
]

{ #category : 'activation' }
OPDiagramFigureFontColorCommand class >> contextMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation
		  byItemOf: OPRoassalShapeFontColorMenuGroup
		  for: OPCanvasPresenter
]

{ #category : 'accessing' }
OPDiagramFigureFontColorCommand class >> defaultColorOf: aDiagramElement [

	^ aDiagramElement defaultFontColor
]
