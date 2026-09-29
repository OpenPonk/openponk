"
Context menu command that allows users to modify the font color of the text within the selected Roassal shape.
"
Class {
	#name : 'OPDiagramFigureFontColorCommand',
	#superclass : 'OPRoassalShapeColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
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
