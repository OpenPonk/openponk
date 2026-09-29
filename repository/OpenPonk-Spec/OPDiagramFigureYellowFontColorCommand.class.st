"
Context menu command that sets the font color of the selected Roassal shape to yellow.
"
Class {
	#name : 'OPDiagramFigureYellowFontColorCommand',
	#superclass : 'OPDiagramFigureFontColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureYellowFontColorCommand class >> color [

	^ Color yellow
]
