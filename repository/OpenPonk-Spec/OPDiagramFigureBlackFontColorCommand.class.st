"
Context menu command that sets the font color of the selected Roassal shape to black.
"
Class {
	#name : 'OPDiagramFigureBlackFontColorCommand',
	#superclass : 'OPDiagramFigureFontColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureBlackFontColorCommand class >> color [

	^ Color black
]
