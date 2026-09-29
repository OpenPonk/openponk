"
Context menu command that sets the stroke color of the selected Roassal shape to yellow.
"
Class {
	#name : 'OPDiagramFigureYellowStrokeColorCommand',
	#superclass : 'OPDiagramFigureStrokeColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureYellowStrokeColorCommand class >> color [

	^ Color yellow
]
