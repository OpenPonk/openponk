"
Context menu command that sets the fill color of the selected Roassal shape to red.
"
Class {
	#name : 'OPDiagramFigureRedFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureRedFillColorCommand class >> color [

	^ Color paleRed
]
