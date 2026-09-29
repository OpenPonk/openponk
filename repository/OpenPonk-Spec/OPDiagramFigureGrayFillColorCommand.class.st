"
Context menu command that sets the fill color of the selected Roassal shape to gray.
"
Class {
	#name : 'OPDiagramFigureGrayFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureGrayFillColorCommand class >> color [

	^ Color veryVeryLightGray
]
