"
Context menu command that sets the fill color of the selected Roassal shape to blue.
"
Class {
	#name : 'OPDiagramFigureBlueFillColorCommand',
	#superclass : 'OPDiagramFigureFillColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureBlueFillColorCommand class >> color [

	^ Color paleBlue
]
