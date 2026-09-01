"
Context menu command that sets the stroke color of the selected Roassal shape to orange.
"
Class {
	#name : 'OPDiagramFigureOrangeStrokeColorCommand',
	#superclass : 'OPDiagramFigureStrokeColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureOrangeStrokeColorCommand class >> color [

	^ Color orange
]
