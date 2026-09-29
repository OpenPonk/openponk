"
Context menu command that sets the stroke color of the selected Roassal shape to red.
"
Class {
	#name : 'OPDiagramFigureRedStrokeColorCommand',
	#superclass : 'OPDiagramFigureStrokeColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureRedStrokeColorCommand class >> color [

	^ Color red
]
