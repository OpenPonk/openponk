"
Context menu command that sets the fill color of the selected Roassal shape to yellow.
"
Class {
	#name : 'OPDiagramFigureYellowFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureYellowFillColorCommand class >> color [

	^ Color paleYellow
]
