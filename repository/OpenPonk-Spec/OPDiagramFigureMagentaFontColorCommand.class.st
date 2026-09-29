"
Context menu command that sets the font color of the selected Roassal shape to magenta.
"
Class {
	#name : 'OPDiagramFigureMagentaFontColorCommand',
	#superclass : 'OPDiagramFigureFontColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureMagentaFontColorCommand class >> color [

	^ Color magenta
]
