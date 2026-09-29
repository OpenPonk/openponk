"
Context menu command that sets the stroke color of the selected Roassal shape to blue.
"
Class {
	#name : 'OPDiagramFigureBlueStrokeColorCommand',
	#superclass : 'OPDiagramFigureStrokeColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureBlueStrokeColorCommand class >> color [

	^ Color blue
]
