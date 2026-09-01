"
Context menu command that sets the font color of the selected Roassal shape to green.
"
Class {
	#name : 'OPDiagramFigureGreenFontColorCommand',
	#superclass : 'OPDiagramFigureFontColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureGreenFontColorCommand class >> color [

	^ Color green
]
