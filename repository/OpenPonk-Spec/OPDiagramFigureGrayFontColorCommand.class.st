"
Context menu command that sets the font color of the selected Roassal shape to gray.
"
Class {
	#name : 'OPDiagramFigureGrayFontColorCommand',
	#superclass : 'OPDiagramFigureFontColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureGrayFontColorCommand class >> color [

	^ Color lightGray
]
