"
Context menu command that sets the font color of the selected Roassal shape to blue.
"
Class {
	#name : 'OPDiagramFigureBlueFontColorCommand',
	#superclass : 'OPDiagramFigureFontColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureBlueFontColorCommand class >> color [

	^ Color blue
]
