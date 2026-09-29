"
Context menu command that allows users to modify the fill color of the selected Roassal shape via its styling properties.
"
Class {
	#name : 'OPDiagramFigureFillColorCommand',
	#superclass : 'OPRoassalShapeColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureFillColorCommand class >> colorAttribute [

	^ #fillColor
]

{ #category : 'activation' }
OPDiagramFigureFillColorCommand class >> contextMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation
		  byItemOf: OPRoassalShapeFillColorMenuGroup
		  for: OPCanvasPresenter
]

{ #category : 'accessing' }
OPDiagramFigureFillColorCommand class >> defaultColorOf: aDiagramElement [

	^ aDiagramElement defaultFillColor
]
