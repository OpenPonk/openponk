"
Context menu command that sets the stroke color of the selected Roassal shape to black.
"
Class {
	#name : 'OPDiagramFigureBlackStrokeColorCommand',
	#superclass : 'OPDiagramFigureStrokeColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureBlackStrokeColorCommand class >> color [

	^ Color black
]
