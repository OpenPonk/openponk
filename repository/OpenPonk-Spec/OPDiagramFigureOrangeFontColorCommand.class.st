"
Context menu command that sets the font color of the selected Roassal shape to orange.
"
Class {
	#name : 'OPDiagramFigureOrangeFontColorCommand',
	#superclass : 'OPDiagramFigureFontColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureOrangeFontColorCommand class >> color [

	^ Color orange
]
