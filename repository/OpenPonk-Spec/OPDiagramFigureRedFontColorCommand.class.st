"
Context menu command that sets the font color of the selected Roassal shape to red.
"
Class {
	#name : 'OPDiagramFigureRedFontColorCommand',
	#superclass : 'OPDiagramFigureFontColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureRedFontColorCommand class >> color [

	^ Color red
]
