"
Context menu command that sets the stroke color of the selected Roassal shape to green.
"
Class {
	#name : 'OPDiagramFigureGreenStrokeColorCommand',
	#superclass : 'OPDiagramFigureStrokeColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureGreenStrokeColorCommand class >> color [

	^ Color green
]
