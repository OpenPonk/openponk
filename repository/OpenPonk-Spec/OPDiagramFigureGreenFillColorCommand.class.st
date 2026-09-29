"
Context menu command that sets the fill color of the selected Roassal shape to green.
"
Class {
	#name : 'OPDiagramFigureGreenFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureGreenFillColorCommand class >> color [

	^ Color paleGreen
]
