"
Context menu command that sets the stroke color of the selected Roassal shape to gray.
"
Class {
	#name : 'OPDiagramFigureGrayStrokeColorCommand',
	#superclass : 'OPDiagramFigureStrokeColorCommand',
	#category : 'OpenPonk-Spec-Commands-RoassalShape',
	#package : 'OpenPonk-Spec',
	#tag : 'Commands-RoassalShape'
}

{ #category : 'accessing' }
OPDiagramFigureGrayStrokeColorCommand class >> color [

	^ Color lightGray
]
