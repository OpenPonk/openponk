"
Context menu command that sets the font color of the selected Roassal shape to white.
"
Class {
	#name : 'OPDiagramFigureWhiteFontColorCommand',
	#superclass : 'OPDiagramFigureFontColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureWhiteFontColorCommand class >> color [

	^ Color white
]
