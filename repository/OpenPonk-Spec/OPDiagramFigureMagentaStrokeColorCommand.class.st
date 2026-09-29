"
Context menu command that sets the stroke color of the selected Roassal shape to magenta.
"
Class {
	#name : 'OPDiagramFigureMagentaStrokeColorCommand',
	#superclass : 'OPDiagramFigureStrokeColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureMagentaStrokeColorCommand class >> color [

	^ Color magenta
]
