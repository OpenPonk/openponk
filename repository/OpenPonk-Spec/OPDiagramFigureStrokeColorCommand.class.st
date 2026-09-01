"
Context menu command that allows users to modify the stroke (border/line) color of the selected Roassal shape.
"
Class {
	#name : 'OPDiagramFigureStrokeColorCommand',
	#superclass : 'OPRoassalShapeColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureStrokeColorCommand class >> colorAttribute [

	^ #strokeColor
]

{ #category : 'activation' }
OPDiagramFigureStrokeColorCommand class >> contextMenuActivation [

	<classAnnotation>
	^ CmdContextMenuActivation
		  byItemOf: OPRoassalShapeStrokeColorMenuGroup
		  for: OPCanvasPresenter
]

{ #category : 'accessing' }
OPDiagramFigureStrokeColorCommand class >> defaultColorOf: aDiagramElement [

	^ aDiagramElement defaultStrokeColor
]
