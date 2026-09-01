"
Context menu command that sets the stroke color of the selected Roassal shape to white.
"
Class {
	#name : 'OPDiagramFigureWhiteStrokeColorCommand',
	#superclass : 'OPDiagramFigureStrokeColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureWhiteStrokeColorCommand class >> color [

	^ Color white
]
